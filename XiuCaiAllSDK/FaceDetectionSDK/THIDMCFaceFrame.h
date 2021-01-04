//
//  THIDMCFaceFrame.h
//  HTJCFaceBaseSdk
//
//  Created by TBoys on 2017/3/14.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THIDMCFaceFrame : NSObject

@property (nonatomic, assign) int faceNumber;
@property (nonatomic, assign) CGRect faceRect;
@property (nonatomic, assign) float fconfidence;
@property (nonatomic, assign) float fQuality;
@property (nonatomic, assign) float brightMean;
@property (nonatomic, assign) float overExposure;
@property (nonatomic, assign) float underExposure;
@property (nonatomic, assign) float sharpness;
@property (nonatomic, assign) float blur;
@property (nonatomic, assign) float motionBlur;

@end
