//
//  ViewController.m
//  toast
//
//  Created by Feng_jun on 15/5/2.
//  Copyright (c) 2015年 Feng_jun. All rights reserved.
//

#import "ViewController.h"
#import "FJToastManager.h"
@interface ViewController ()<UITextFieldDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
- (IBAction)btnTaped:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 10001:
        {
            [FJToastManager showToast:@"message"];
        }
            break;
        case 10002:
        {
            [FJToastManager showToast:@"message 5 second"
                             duration:5.0f];
        }
            break;
        case 10003:
        {
            [FJToastManager showToast:@"message taped execute code"
                             duration:3.0f
                          tapCallback:^{
                                 NSLog(@"toast taped");
                          }];
        }
            break;
        case 10004:
        {
            [FJToastManager showToast:@"message taped or completed execute code"
                             duration:3.0f
                          tapCallback:^{
                                 NSLog(@"toast taped");
            }
                             complete:^{
                                 NSLog(@"toast completed");
            }];
        }
            break;
        case 10005:
        {
            [FJToastManager showToast:@"message until finish it" duration:0];
        }
            break;
        case 10006:
        {
            [FJToastManager hidden];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
