//
//  EXOCRQuadCustomScanView.h
//  ExCardSDK
//
//  Created by 肖尧 on 2017/6/9.
//  Copyright © 2017年 kubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QuadImageNoError,       //图像合格
    QuadImagePointError,    //点错误
    QuadImageAreaError,     //面积错误
    QuadImageAngleError,    //角度错误
    QuadImageFocusError,    //模糊错误
    QuadImageReflectiveError,//反光错误
} QuadImageError;

/**
 *	@brief 四边定位自定义扫描视图协议
 *
 *	@discussion 四边定位自定义扫描视图，须实现协议中的代理方法
 */
@protocol EXOCRQuadCustomScanViewDelegate <NSObject>
@required
/**
 四边定位坐标回调，可根据坐标刷新UI(每次识别实时调用该方法)，如果四个点坐标都为(375,0)，则为定位失败

 @param topLeft 四边定位点坐标(左上)
 @param topRight 四边定位点坐标(右上)
 @param bottomLeft 四边定位点坐标(左下)
 @param bottomRight 四边定位点坐标(右下)
 */
-(void)getQuadRectTopLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight;

/**
 *  @brief   识别图像错误回调，可根据错误码刷新UI提示用户(每次识别实时调用该方法)
 *  @param   imageError  - 图像错误码
 *           orientation - 扫描页面方向
 */
-(void)imageError:(QuadImageError)imageError WithOrientation:(UIInterfaceOrientation)orientation;

/**
 *  @brief   识别完成，获取识别结果
 *  @param   info - 识别结果模型
 */
-(void)recoCompleted:(id)info;

@optional

/**
 *  @brief   识别完成，获取识别结果通用模型
 *  @param   quadInfo - 识别结果模型（EXOCRQuadInfo）
 */
-(void)recoCompletedCommon:(id)quadInfo;

/**
 识别图像光强回调(每次识别实时调用该方法)

 @param lightIntensity 识别图像光强(数值大约为-5~12，数值约小，亮度越低，数值越大，亮度越高)
 */
-(void)getLightIntensity:(float)lightIntensity;

/**
 识别超时回调
 
 @param image 回调图像
 */
-(void)recoTimeout:(UIImage *)image;

/**
 识别暂停时回调（须开启设置：扫描页启停识别）
 */
-(void)refreshScanViewByRecoPause;

/**
 识别继续时回调（须开启设置：扫描页启停识别）
 */
-(void)refreshScanViewByRecoContinue;
@end
