//
//  FJToastView.m
//  toast
//
//  Created by Feng_jun on 15/5/2.
//  Copyright (c) 2015年 Feng_jun. All rights reserved.
//

#import "FJToastView.h"
#import <objc/runtime.h>



#define SCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define SYSTEM_VERSIOIN    ([[UIDevice currentDevice].systemVersion floatValue])
#define MAX_WIDTH          (SCREEN_WIDTH * 0.7f)
#define LEFT_PADDING       20
#define RIGHT_PADDING      20
#define TOP_PADDING        10
#define BOTTOM_PADDING     10

static const NSTimeInterval FJAnimationDuration = 0.5;

static const NSString *FJToastTapKey            = @"FJToastTapKey";
static const NSString *FJToastTimerKey          = @"FJToastTimerKey";
static const NSString *FJToastCompleteKey       = @"FJToastCompleteKey";


@implementation FJToastView

- (instancetype)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration tapCallback:(callback)tapCallback complete:(callback)complete
{
    self = [super init];
    if (self)
    {
        if (message == nil)
        {
            return nil;
        }
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.alpha = 0.0f;
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize messageSize = [message sizeWithFont:label.font constrainedToSize:CGSizeMake(MAX_WIDTH, SCREEN_HEIGHT) lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
        
        label.frame = CGRectMake(LEFT_PADDING, TOP_PADDING , messageSize.width, messageSize.height);
        self.frame = CGRectMake(0, 0, messageSize.width + LEFT_PADDING + RIGHT_PADDING, messageSize.height + TOP_PADDING + BOTTOM_PADDING);
        [self addSubview:label];
        self.center = CGPointMake(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f);
        
        //event

        if (duration>0)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toastTaped)];
            [self addGestureRecognizer:tap];
            
            objc_setAssociatedObject(self, &FJToastTapKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(finishTimer:) userInfo:nil repeats:NO];
            objc_setAssociatedObject(self, &FJToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        objc_setAssociatedObject(self, &FJToastCompleteKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return self;
}


-(void)hiddenToast
{
    [UIView animateWithDuration:FJAnimationDuration
                    animations:^{self.alpha = 0.0f;}
                    completion:^(BOOL finished) {[self removeFromSuperview];}
     ];
}

- (void)toastTaped
{
    callback tapCallback = objc_getAssociatedObject(self, &FJToastTapKey);
    NSTimer *timer = objc_getAssociatedObject(self, &FJToastTimerKey);
    if (tapCallback)
    {
        tapCallback();
    }
    if (timer)
    {
        [timer invalidate];
    }
    
    [self hiddenToast];
}

- (void)finishTimer:(NSTimer *)timer
{
    callback complete = objc_getAssociatedObject(self, &FJToastCompleteKey);
    if (complete)
    {
        complete();
    }
    
    if (timer)
    {
        [timer invalidate];
    }
    [self hiddenToast];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
