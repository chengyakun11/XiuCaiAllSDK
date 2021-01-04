//
//  EXOCRFaceRecordManager.h
//  EXCORFaceRecord
//
//  Created by TBoys on 2017/11/17.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EXRecordModel.h"
#import <UIKit/UIKit.h>

@protocol EXRecordDelegate <NSObject>

//调用摄像头失败
- (void)captureDidStopRunningWithError:(NSError *)error;
//开始录制回调
- (void)recordingDidStart;
//即将结束录制回调
- (void)recordingWillStop;
//结束录制回调
- (void)recordingDidStop;
//录制失败
- (void)recordingDidFailedWithError:(NSError *)error;

@end

@interface EXRecordManager : NSObject

//设置录制视频的方向, 默认 AVCaptureVideoOrientationPortrait
@property(atomic) AVCaptureVideoOrientation recordingOrientation;

//录制视频存储路径,请自行清理沙盒
@property (nonatomic, copy) NSString *videoPath;

//是否正在捕获视频帧
@property (atomic, assign, readonly) BOOL isCapturing;

@property (nonatomic, weak) id<EXRecordDelegate> delegate;

//初始化manager
- (instancetype)initWithPreview:(UIView *)preview param:(EXRecordModel *)recordModel;

//启动session
- (void)startCameraSession;

//暂停session
- (void)pauseCameraSession;

//关闭session
- (void)stopCameraSession;

//开始录制
- (void)startRecording;

//停止录制
- (void)stopRecording;

//获取视频第一帧图片
- (void)movieToImage:(NSString *)videoPath withHandler:(void (^)(UIImage *movieImage))handler;

//视频加水印, 这里适当的压缩了视频 最多减少 30%
- (void)addWatermark:(CALayer *)markLayer videoPath:(NSString *)videoPath toPath:(NSString *)newPath completed:(void(^)(BOOL success))completed;

@end
