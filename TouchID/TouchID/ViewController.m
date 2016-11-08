//
//  ViewController.m
//  TouchID
//
//  Created by 胥鸿儒 on 16/9/8.
//  Copyright © 2016年 胥鸿儒. All rights reserved.
//
#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "XHRTouchIDTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"点击调用" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
- (void)actionDidClickButton:(UIButton *)sender
{
    [self touchIDTest];
}
- (void)touchIDTest
{
    [XHRTouchIDTool validateTouchID];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDSuccess) name:XHRValidateTouchIDSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotAvailable) name:XHRValidateTouchIDNotAvailable object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotEnrolled) name:XHRValidateTouchIDNotEnrolled object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDAuthenticationFailed) name:XHRValidateTouchIDAuthenticationFailed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDCancel) name:XHRValidateTouchIDCancel object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionTouchIDLockout) name:XHRValidateTouchIDLockout object:nil];
}
- (void)actionDidReceiveValidateTouchIDSuccess
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDNotAvailable
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDNotEnrolled
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDAuthenticationFailed
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDCancel
{
    NSLog(@"%s",__func__);
}
- (void)actionTouchIDLockout
{
    NSLog(@"%s",__func__);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
