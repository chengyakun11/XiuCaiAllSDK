//
//  Camera.h
//  apexsoftiOSBaseLib
//
//  Created by chenxiaosen on 2019/6/5.
//  Copyright © 2019年 com.apex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^connectVideo)(NSDictionary *);
typedef void (^showVideo)(NSDictionary *);
typedef void (^getVersion)(NSDictionary *);
typedef void (^updateVersion)(NSDictionary *);
typedef void (^sendDataToNative)(NSDictionary *);
typedef void (^disconnectVideo)();
typedef void (^dismissVC)();
@interface Camera : UIViewController
@property (strong,nonatomic)NSURL *url;
@property (nonatomic,copy) connectVideo connectVideo;
@property (nonatomic,copy) showVideo showVideo;
@property (nonatomic,copy) getVersion getVersion;
@property (nonatomic,copy) updateVersion updateVersion;
@property (nonatomic,copy) sendDataToNative sendDataToNative;
@property (nonatomic,copy) disconnectVideo disconnectVideo;
@property (nonatomic,copy) dismissVC dismissVC;
-(void)sendVideoResult:(NSDictionary *)resultDict;
-(void)sendH5hs:(NSString *)H5hs;//发送h5话术
-(void)sendH5Version:(NSString *)H5Version;//发送应用版本号
@end

NS_ASSUME_NONNULL_END
