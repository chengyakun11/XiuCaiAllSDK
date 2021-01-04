//
//  VideoModalViewController.h
//  webSDKDemo
//
//  Created by chenxiaosen on 2020/5/8.
//  Copyright © 2020 com.apex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZQOpenStartVideoWitnessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoModalViewController : UIViewController

@property (nonatomic, copy)void(^startVideoCallBackBlk)(BOOL isSuccess,NSString *reason);
@property (nonatomic, copy)void(^anyChatTextMsgCallBack)(NSString *textMsg);
@property(nonatomic,strong)XYZQOpenStartVideoWitnessModel *userVideoInfo;
@property(nonatomic,strong)NSDictionary *params;

- (void)stopVideoChat:(BOOL)isSuccess failReasonRemark:(NSString*)failReasonRemark;
- (void)stopVideo;

@end


NS_ASSUME_NONNULL_END
