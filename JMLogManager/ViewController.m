//
//  ViewController.m
//  JMLogManager
//
//  Created by JiangMing on 2019/8/12.
//  Copyright © 2019 JiangMing. All rights reserved.
//

#import "ViewController.h"
#import "JMLogManager.h"


@interface ViewController ()
@property(strong,nonatomic)NSTimer *timer;
@property(assign,nonatomic)NSInteger times;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JMLogManager defultLogManager].isShowOnOutput = YES;
    [JMLogManager defultLogManager].isWriteToFile = YES;
    [[JMLogManager defultLogManager] startShowLogView:YES];
 
      
    self.timer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:3 target:self selector:@selector(outputLog) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view.
}
- (void)outputLog{
    self.times ++;
    NSLog(@"这是第%ld次打印", (long)self.times);
}

@end
