//
//  JMLogManager.m
//  JMLogManager
//
//  Created by JiangMing on 2019/8/12.
//  Copyright © 2019 JiangMing. All rights reserved.
//

#import "JMLogManager.h"
#include <sys/time.h>
#import "JMLogView.h"

static JMLogManager *logManager = nil;
int logfd = -1 ;
BOOL hasStart = NO;
BOOL showLogView = YES;

@interface JMLogManager()

@property (strong, atomic) NSPipe *pipe;
@property (assign) int orig_stderr;
@property (assign) int orig_stdout;


@end

@implementation JMLogManager


#pragma public
+ (JMLogManager *)defultLogManager{
    if (logManager!=nil) {
        return logManager;
    }
    
    @synchronized(self){
        if (logManager==nil) {
            logManager=[[self alloc]init];
        }
    }
    return logManager;
}

- (void)startShowLogView:(BOOL)show{
    if (hasStart) {
        return;
    }
    showLogView = show;
    hasStart = YES;
    _pipe = [NSPipe pipe];
    _orig_stdout = dup(STDOUT_FILENO);
    _orig_stderr = dup(STDERR_FILENO);
    dup2(_pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO);
    dup2(_pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO);
    [self performSelectorInBackground:@selector(handlePipe) withObject:nil];
}


- (void)setIsWriteToFile:(BOOL)isWriteToFile{
    if (isWriteToFile) {
        [self enableWriteToFile];
    }else{
        [self disableWriteToFile];
    }
}

#pragma pravite
- (void)enableWriteToFile{
    int old_logfd = logfd;
    int f_fd = open([self getLogFile].UTF8String, O_WRONLY|O_CREAT|O_APPEND, 0644);
    if (f_fd < 0) {
        NSLog(@"error opening logfile: %s", strerror(errno));
    }
    logfd = f_fd;
    if (old_logfd > 0)
        close(old_logfd);
}

- (void)disableWriteToFile{
    int old_logfd = logfd;
    logfd = -1;
    if (old_logfd > 0)
        close(old_logfd);
}

- (void)handlePipe{
    fd_set fds;
    int input_fd = _pipe.fileHandleForReading.fileDescriptor;
    int rv;
    do {
        FD_ZERO(&fds);
        FD_SET(input_fd, &fds);
        rv = select(FD_SETSIZE, &fds, NULL, NULL, NULL);
        if (FD_ISSET(input_fd, &fds)) {
            NSString *read = [self readDataFromFD:input_fd toFD:_orig_stdout];
            if (read == nil)
                continue;
            if (showLogView) {
                 [self updateViewWithText:read];
            }
        }
    } while (rv > 0);
}


- (NSString *)readDataFromFD:(int)infd toFD:(int)outfd{
    char s[0x10000];
    ssize_t nread = read(infd, s, sizeof(s));
    if (nread <= 0)
        return nil;
    if (self.isShowOnOutput) {
        write(outfd, s, nread);
    }
    if (logfd > 0) {
        if (write(logfd, s, nread) != nread) {
            write(_orig_stderr, "error writing to logfile\n", 26);
        }
    }
    return [[NSString alloc] initWithBytes:s length:nread encoding:NSUTF8StringEncoding];
}

- (NSString *)getLogFile{
    if (!self.logPath || !self.logPath.length) {
        self.logPath = @"Documents/JMlog.txt";
    }
    static NSString *logfile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logfile = [NSHomeDirectory() stringByAppendingPathComponent:self.logPath];
    });
    return logfile;
}

- (BOOL)cleanLogs{
    NSString *path = [self getLogFile];
    if ([[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return NO;
}

- (void)updateViewWithText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JMLogView defultLogView] updateViewWithText:text];
    });

}

@end
