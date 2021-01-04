//
//  HTJCLiveDetectDelegate.h
//  HTJCFaceLiveDetectSdk
//
//  Created by TBoys on 2017/12/4.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTJCDefineHeader.h"

@protocol HTJCLiveDetectDelegate <NSObject>

- (void)beginFaceGuide;

- (void)beginMovementDetect;

- (void)faceDetecting:(HTJCReturnValue)returnType;

- (void)liveDetectingControl:(HTJCMovementType)movementType;

- (void)detectSuccess;

- (void)detectFail;


@end
