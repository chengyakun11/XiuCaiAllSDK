//
//  THIDMCHTJCViewManger.h
//  THIDMCHTJCViewManger
//
//  Created by TBoys on 2017/3/9.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTJCFaceLiveDetectManager : NSObject

/**  获取实例对象
 *
 *  _vc : 传入当前控制器
 */
+ (HTJCFaceLiveDetectManager *)sharedManager:(UIViewController*)_vc;

/** 弹出活检控制器的方式
 *
 *  @param type 0: add方式; 1: present方式; 2: push方式
 *  @param animated 系统过渡动画
 */
- (void)setPopType:(NSInteger)type animated:(BOOL)animated;

/** 配置动作数组(有默认动作)
 *
 *  @param liveDetectTypeArray 参考头文件 HTJCDefineHeader.h 定义
 */
- (void)setLiveDetectTypeArray:(NSArray *)liveDetectTypeArray;

/** 自定义活体检测器界面
 *
 * @param preview 承载自定义view ,且 _cancel 不会回调
 * @param layerRect 设置摄像头预览区域,
 * @param delegate 主线程回调活体检测信息, 可配合preview实现 界面自定义
 */
- (void)setPreview:(UIView *)preview layerRect:(CGRect)layerRect withDelegate:(id)delegate;

/** 设置了 preview 后 此接口才有效
 *
 *  @param limitRect 人脸检测框的frame
 */
- (void)setFaceLimit:(CGRect)limitRect;

/** 设置是否开始检测
 *
 *  @param startDetect 默认否
 */
- (void)setStartDetect:(BOOL)startDetect;

/** 活体检测核心接口
 *
 * @param _completion: 成功回调 需要手动退出活体检测器
 * @param _cancel: 取消回调 自动退出活体检测器 如果自定义界面则不会有回调且要在自定义的退出方法里手动退出活体检测器
 * @param _failed: 失败回调 自动退出活体检测器
 */
- (void)getLiveDetectCompletion:(void (^)(BOOL success, NSData * imageData))_completion
                        cancel:(void (^)(BOOL success, NSError* error))_cancel
                        failed:(void (^)(NSError *error, NSData *imageData))_failed;

/**
 *
 *  退出活体检测器, 特殊情况下需手动调用
 */
- (void)dismissTakeCaptureSessionViewController;


#pragma mark -
#pragma mark 内部版本记录
/**
 *  获取framework版本号
 *
 *  @return 版本号
 */
- (NSString *)getBundleVersion;

/**
 *  获取算法SDK版本号
 *
 *  @return 版本号
 */
- (NSString *)getSDKVersion;

@end
