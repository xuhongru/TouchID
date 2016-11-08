//
//  XHRTouchIDTool.h
//  TouchID
//
//  Created by 胥鸿儒 on 16/9/8.
//  Copyright © 2016年 胥鸿儒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHRTouchIDTool : NSObject
// 当识别出现每一种情况是会发出通知
+ (void)validateTouchID;
@end
/*
 * 授权成功
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDSuccess;
/*
 * 取消按钮
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDCancel;
/*
 * 输入密码
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDInputPassword;
/*
 * 授权失败
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDAuthenticationFailed;
/*
 * 设备不可用
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDNotAvailable;
/*
 * 设备未设置指纹
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDNotEnrolled;
/*
 * 设备未设置密码
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDErrorPasscodeNotSet;
/*
 * 指纹设备被锁定
 */
UIKIT_EXTERN NSString *const XHRValidateTouchIDLockout;
