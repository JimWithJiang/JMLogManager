//
//  JMLogView.h
//  JMLogManager
//
//  Created by JiangMing on 2019/8/12.
//  Copyright © 2019 JiangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMLogView : UIWindow

+ (JMLogView *)defultLogView;

- (void)updateViewWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
