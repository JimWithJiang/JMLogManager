//
//  JMLogView.m
//  JMLogManager
//
//  Created by JiangMing on 2019/8/12.
//  Copyright © 2019 JiangMing. All rights reserved.
//

#import "JMLogView.h"


static JMLogView *logView = nil;

bool isMove = NO;



@interface JMLogView()

@property(weak,nonatomic)UITextView *textView;


@end

@implementation JMLogView

+ (JMLogView *)defultLogView{
    if (logView != nil) {
        return logView;
    }
    
    @synchronized(self){
        if (logView == nil) {
            logView = [[self alloc]init];
        }
    }
    return logView;
}

- (id)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 200);
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.clipsToBounds = YES;
        self.hidden = NO;
        
        UITextView *textView = [[UITextView alloc]init];
        textView.frame = self.bounds;
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:12.0f];
        textView.textColor = [UIColor whiteColor];
        textView.text = @"start";
        [self addSubview:textView];
        self.textView = textView;
        
        UIButton *isHiddenBtn = [[UIButton alloc]init];
        isHiddenBtn.backgroundColor = [UIColor lightGrayColor];
        isHiddenBtn.frame = CGRectMake(self.bounds.size.width - 60, self.bounds.origin.y, 50, 50);
        isHiddenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [isHiddenBtn setTitle:@"hidden" forState:UIControlStateNormal];
        [isHiddenBtn addTarget:self action:@selector(isHiddenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:isHiddenBtn];
        
    }
   return self;
}



- (void)updateViewWithText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(),^{
        self.textView.text = [NSString stringWithFormat:@"%@\n%@",self.textView.text, text];
        NSRange range = NSMakeRange([self.textView.text length] - 1, 0);
        [self.textView scrollRangeToVisible:range];
    });
}

- (void)isHiddenBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"hidden"]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 30 , 50, 50);
            btn.frame = self.bounds;
            [btn setTitle:@"show" forState:UIControlStateNormal];
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 200);
            btn.frame = CGRectMake(self.bounds.size.width - 60, self.bounds.origin.y, 50, 50);
            [btn setTitle:@"hidden" forState:UIControlStateNormal];
        } completion:nil];
    }
}


@end
