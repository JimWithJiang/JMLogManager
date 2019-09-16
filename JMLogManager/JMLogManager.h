//
//  JMLogManager.h
//  JMLogManager
//
//  Created by JiangMing on 2019/8/12.
//  Copyright © 2019 JiangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMLogManager : NSObject
/*是否在Xcode显示NSLog输出，默认NO*/
@property(assign,nonatomic)BOOL isShowOnOutput;

/*是否将NSLog输出存储到沙盒，默认NO*/
@property(assign,nonatomic)BOOL isWriteToFile;
/*默认路径为Documents/JMlog.txt*/
@property(copy,nonatomic)NSString *logPath;



+ (JMLogManager *)defultLogManager;

/*开启日志重定向, 是否显示实时输出控制台*/
- (void)startShowLogView:(BOOL)show;


@end

NS_ASSUME_NONNULL_END
