//
//  PermissionUtil.m
//  Open2.0
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZQOpenUIAlertView.h"
#import <Foundation/Foundation.h>
#import "XYZQPermissionUtil.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>

#define MYSystemVersionAfter(version)    ([[UIDevice currentDevice]systemVersion].floatValue > version)

@implementation XYZQPermissionUtil


- (BOOL)PermissionPhoto:(BOOL)tip
{
    __block BOOL result = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //相机授权检查
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                result = YES;
            } else {
                if(tip==true){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XYZQOpenUIAlertView showAlertWithTitle:@"权限提示"
                                                        message:@"相册权限暂未开启，请到设置界面修改"
                                                   cancelButton:@"取消"
                                                   otherButtons:@[@"确定"]
                                                  buttonHandler:^(XYZQOpenUIAlertView* alert, NSInteger buttonIndex) {
                                                      if(buttonIndex==0) return ;
                                                      if(MYSystemVersionAfter(8.0)) {
                                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          
                                                      }/*else
                                                        {
                                                        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];                                   [[UIApplication sharedApplication] openURL:url];
                                                        }*/
                                                  }];
                    });
                    
                }
                result = NO;
            }
            dispatch_semaphore_signal(sema);
        }];
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return result;
//    int status = [ALAssetsLibrary authorizationStatus];
//    if(status == 2){ //拒绝授权
//        if(tip==true){
//            [XYZQOpenUIAlertView showAlertWithTitle:@"权限提示"
//                                    message:@"相册权限暂未开启，请到设置界面修改"
//                                    cancelButton:@"取消"
//                                    otherButtons:@[@"确定"]
//                              buttonHandler:^(XYZQOpenUIAlertView* alert, NSInteger buttonIndex) {
//                                  if(buttonIndex==0) return ;
//                                  if(MYSystemVersionAfter(8.0)) {
//                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//
//                                  }/*else
//                                  {
//                                      NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];                                   [[UIApplication sharedApplication] openURL:url];
//                                  }*/
//                              }];
//        }
//        return NO;
//    }
//    return YES;
}

- (BOOL )PermissionCamera:(BOOL)tip
{
    //相机授权检查
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusDenied){ //拒绝授权
         if(tip==true){
            [XYZQOpenUIAlertView showAlertWithTitle:@"权限提示"
                                    message:@"相机权限暂未开启，请到设置界面修改"
                                    cancelButton:@"取消"
                                    otherButtons:@[@"确定"]
                              buttonHandler:^(XYZQOpenUIAlertView* alert, NSInteger buttonIndex) {
                                if(buttonIndex==0) return ;
                                  if(MYSystemVersionAfter(8.0)) {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                  }/*else
                                  {
                                      NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                                      [[UIApplication sharedApplication] openURL:url];
                                  }*/
                                  
                              }];
         }
        return NO;
    }
    return YES;
    
}


- (BOOL )PermissionMicrophone:(BOOL)tip
{
    //相机授权检查
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(status == AVAuthorizationStatusDenied){ //拒绝授权
         if(tip==true){
            [XYZQOpenUIAlertView showAlertWithTitle:@"权限提示"
                                    message:@"麦克风权限暂未开启，请到设置界面修改"
                                    cancelButton:@"取消"
                                    otherButtons:@[@"确定"]
                              buttonHandler:^(XYZQOpenUIAlertView* alert, NSInteger buttonIndex) {
                                  if(buttonIndex==0) return ;
                                  if(MYSystemVersionAfter(8.0)) {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                  }/*else
                                  {
                                      NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy"];                               [[UIApplication sharedApplication] openURL:url];
                                  }*/
                              }];
         }
        return NO;
    }
    return YES;
   
}


- (BOOL)PermissionLocation:(BOOL)tip
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        if(tip==NO)return NO;
        [XYZQOpenUIAlertView showAlertWithTitle:@"权限提示"
                                    message:@"地理位置权限暂未开启，请到设置界面修改"
                                   cancelButton:@"取消"
                                   otherButtons:@[@"确定"]
                              buttonHandler:^(XYZQOpenUIAlertView* alert, NSInteger buttonIndex) {
                                  if(buttonIndex==0) return ;
                                  if(MYSystemVersionAfter(8.0)) {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                  }/*else
                                  {
                                      NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy"];                               [[UIApplication sharedApplication] openURL:url];
                                  }*/
                              }];
        

        
         return NO;
    }
    return YES;
   

}


- (BOOL)PermissionCellularNetwork:(BOOL)tip
{
    return YES;
}


@end
