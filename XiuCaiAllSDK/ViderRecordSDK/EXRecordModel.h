//
//  EXRecordModel.h
//  EXCORFaceRecord
//
//  Created by TBoys on 2017/11/18.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXRecordModel : NSObject

//摄像头preset 建议使用 AVCaptureSessionPreset640x480
@property (nonatomic, copy) NSString *sessionPreset;

// 视频宽 建议 480
@property (nonatomic, assign) int cx;

// 视频高 建议 640
@property (nonatomic, assign) int cy;

//视频码率比 越大视频越清晰 体积越大,建议 2.0
//ps: AVVideoAverageBitRateKey = bitRateRatio * cx * cy
@property (nonatomic, assign) float bitRateRatio;

//视频帧率 建议 25
@property (nonatomic, assign) int frameRate;

//视频关键帧最大间隔 1为每个都是关键帧，数值越大压缩率越高 建议为 30
@property (nonatomic, assign) int maxKeyFrame;

@end
