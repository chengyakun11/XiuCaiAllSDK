//
//  THIDMCFaceLiveBaseManger.h
//  HTJCFaceBaseSdk
//
//  Created by TBoys on 17/3/5.
//  Copyright (c) 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THIDMCFaceFrame.h"

@interface THIDMCFaceLiveBaseManger : NSObject

@property (nonatomic, strong) NSArray *liveDetectArr;
@property (nonatomic, strong, readonly) NSArray *liveDetectValueCache;

//获取实例对象
+ (THIDMCFaceLiveBaseManger *)sharedManager;

/*      初始化配置
 *
 *      _sucessed：成功回调
 *      _failed：失败回调
 */
- (void)initializedSdkSuccess:(void (^)(BOOL success))_sucessed failed:(void (^)(NSString *error))_failed;

/*      向SDK发送图片
 *
 *      detectImage：抓到的每帧图片
 *      _handle：每帧进程回调
 *
 */
- (void)getLiveDetectProcessPushed:(UIImage *)detectImage withHandle:(void(^)(NSInteger procedueState, NSInteger returnVal, THIDMCFaceFrame *faceFrame))_handle;

/*      切换下一个动作
 *
 *      _nextState：回调下一个动作
 */
- (void)setNextStepLiveDetection:(void (^)(NSInteger state))_nextState;

//根据图片获取人脸框
- (CGRect)getFaceRectWithImage:(UIImage*)image;

//图片加密
- (NSData *)getEcryptFaceRectImage:(UIImage*)_image;
- (NSData *)getEcryptFaceRectImage:(UIImage*)_imageOne imageData:(NSData *)imageData;

//插入图片数据
- (NSData *)insertImage:(NSData *)imageData toImage:(NSData *)inputImageData;

//插图图片内容
- (NSData *)insertDetectName:(NSString *)detectName toImage:(NSData *)inputImageData;

//释放/反初始化 SDK
- (void)uninitSDK;


@end
