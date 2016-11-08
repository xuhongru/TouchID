//
//  XHRTouchIDTool.m
//  TouchID
//
//  Created by 胥鸿儒 on 16/9/8.
//  Copyright © 2016年 胥鸿儒. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XHRTouchIDTool.h"
#import <LocalAuthentication/LocalAuthentication.h>
#define XHRDeviceVersion [[UIDevice currentDevice]systemVersion].doubleValue
/*
 * 授权成功
 */
NSString *const XHRValidateTouchIDSuccess = @"XHRValidateTouchIDSuccess";
/*
 * 取消按钮
 */
NSString *const XHRValidateTouchIDCancel = @"XHRValidateTouchIDCancel";
/*
 * 输入密码
 */
NSString *const XHRValidateTouchIDInputPassword = @"XHRValidateTouchIDInputPassword";
/*
 * 授权失败
 */
NSString *const XHRValidateTouchIDAuthenticationFailed = @"XHRValidateTouchIDAuthenticationFailed";
/*
 * 设备指纹不可用
 */
NSString *const XHRValidateTouchIDNotAvailable = @"XHRValidateTouchIDNotAvailable";
/*
 * 设备未设置指纹
 */
NSString *const XHRValidateTouchIDNotEnrolled = @"XHRValidateTouchIDNotEnrolled";
/*
 * 设备未设置密码
 */
NSString *const XHRValidateTouchIDErrorPasscodeNotSet = @"XHRValidateTouchIDErrorPasscodeNotSet";
/*
 * 指纹设备被锁定
 */
NSString *const XHRValidateTouchIDLockout = @"XHRValidateTouchIDLockout";
@implementation XHRTouchIDTool
+ (void)validateTouchID
{
    // 判断系统是否是iOS8.0以上 8.0以上可用
    if (!([[UIDevice currentDevice]systemVersion].doubleValue >= 8.0)) {
        NSLog(@"系统不支持");
        return;
    }
    // 创建LAContext对象
    LAContext *authenticationContext = [[LAContext alloc]init];
    NSError *error = nil;
    authenticationContext.localizedFallbackTitle = @"";

    [authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error.code == LAErrorTouchIDLockout && XHRDeviceVersion >= 9.0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDLockout object:nil];
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self validateTouchID];
            }
        }];
        return;
    }
    [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 指纹识别错误调用分为以下情况,
            // 点击取消按钮 : domain = com.apple.LocalAuthentication code = -2
            // 点击输入密码按钮 : domain = com.apple.LocalAuthentication code = -3
            // 输入密码重新进入指纹系统 : domain = com.apple.LocalAuthentication code = -8
            // 指纹三次错误 : domain = com.apple.LocalAuthentication code = -1
            // 指纹验证成功 : error = nil
            if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        NSLog(@"LAErrorAuthenticationFailed");
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDAuthenticationFailed object:nil];
                        break;
                    case LAErrorUserCancel:
                        // 点击取消按钮
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDCancel object:nil];
                        break;
                    case LAErrorUserFallback:
                        // 用户点击输入密码按钮
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDInputPassword object:nil];
                        break;
                    case LAErrorPasscodeNotSet:
                        //没有在设备上设置密码
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDErrorPasscodeNotSet object:nil];
                        break;
                    case LAErrorTouchIDNotAvailable:
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDNotAvailable object:nil];
                        //设备不支持TouchID
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDNotEnrolled object:nil];
                        break;
                        //设备没有注册TouchID
                    case LAErrorTouchIDLockout:
                        [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDLockout object:nil];
                        if (XHRDeviceVersion >= 9.0) {
                            [self validateTouchID];
                        }
                        break;
                    default:
                        break;
                }
                return ;
            }
            // 说明验证成功,如果要刷新UI必须在这里回到主线程
            [[NSNotificationCenter defaultCenter]postNotificationName:XHRValidateTouchIDSuccess object:nil];
        });
    }];
}

@end
