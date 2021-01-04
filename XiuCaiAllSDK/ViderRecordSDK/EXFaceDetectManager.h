//
//  EXFaceDetectManager.h
//  EXCORFaceRecord
//
//  Created by TBoys on 2017/11/18.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@interface EXFaceFrameInfo : NSObject

@property(nonatomic,assign)int faceNum;
@property(nonatomic,assign)CGRect faceRect;
@property(nonatomic,assign)float brightMean;
@property(nonatomic,assign)float sharpness;

@end

@interface EXFaceDetectManager : NSObject

- (EXFaceFrameInfo *)faceDetectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

//smapleBuffer 转 UIImage
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer withRotation:(UIImageOrientation)orientation;

- (EXFaceFrameInfo *)faceDetectWithImage:(UIImage *)aImage;

//根据人脸rect 裁剪图片
- (UIImage *)clipFace:(UIImage *)aImage withFaceRect:(CGRect)faceRect;

@end
