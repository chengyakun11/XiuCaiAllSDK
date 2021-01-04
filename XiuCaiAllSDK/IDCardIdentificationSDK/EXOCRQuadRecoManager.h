//
//  EXOCRQuadRecoManager.h
//  quadcard
//
//  Created by 肖尧 on 17/2/21.
//  Copyright © 2017年 肖尧. All rights reserved.

#import <Foundation/Foundation.h>
#import "EXOCRQuadCardInfo.h"

/**
 *	@brief 识别回调EXOCRCompletedQuadCardParticularBlock, EXOCRCompletedIDCardBlock, EXOCRCanceledBlock, EXOCRFailedBlock
 *
 *	@discussion 用来设定异步调用的回调
 */
typedef void (^EXOCRCompletedQuadCardParticularBlock)(int statusCode, id cardInfo);
typedef void (^EXOCRCompletedQuadCardBlock)(int statusCode, EXOCRQuadCardInfo *quadInfo);
typedef void (^EXOCRCanceledBlock)(int statusCode);
typedef void (^EXOCRFailedBlock)(int statusCode, UIImage *recoImg);

typedef enum : NSUInteger {
    EXOCRCardTypeIDCARD,                //身份证
    
} EXOCRCardType;

@interface EXOCRQuadRecoManager : NSObject
/**
 获取EXOCRQuadRecoManager实例化对象

 @param vc 传入target控制器
 @return EXOCRQuadRecoManager对象
 */
+(instancetype)sharedManager:(UIViewController *)vc;

/**
 * @brief 扫描页面调用方式设置，设置扫描页面调用方式
 * @param bByPresent - 是否以present方式调用，默认为NO，YES-以present方式调用，NO-以sdk默认方式调用(push或present)
 */
-(void)displayScanViewControllerByPresent:(BOOL)bByPresent;

/**
 * @brief 设置扫描超时时间，默认扫描视图在failblock中回调，自定义扫描视图在代理方法recoTimeout中回调（自定义扫描视图建议自行添加超时逻辑，不使用该接口）
 * @param timeout - 超时时间（默认为0，无超时）
 */
-(void)setRecoTimeout:(NSTimeInterval)timeout;

/**
 * @brief 取图设置，设置取图模式（目前支持三种取图模式），当前版本仅对身份证识别生效
 * @param imageMode - 取图模式（可配置取图模式在EXOCRQuadCardInfo.h中定义）
 */
-(void)setImageMode:(int)imageMode;

/**
 * @brief 取图设置，设置取图模式（目前支持三种取图模式），当前版本仅对身份证识别生效
 * @param imageMode - 取图模式（可配置取图模式在EXOCRQuadCardInfo.h中定义）
 * @param borderWidth - 留白宽度（仅在imageMode为QUAD_IMAGEMODE_HIGH时支持, 范围1-128）
 */
-(void)setImageMode:(int)imageMode AndBorderWidth:(int)borderWidth;

/**
 TabBarController是否交给SDK设置隐藏
 
 @param bControl 是否交给SDK控制（YES:扫描页隐藏TabBarController，退出扫描页时显示;NO:由开发者自行控制TabBarController是否隐藏;默认为YES）
 */
-(void)controlTabBarControllerHiddenBySDK:(BOOL)bControl;

/**
 NavigationrController是否交给SDK设置隐藏
 
 @param bControl 是否交给SDK控制（YES:扫描页隐藏NavigationrController，退出扫描页时显示;NO:由开发者自行控制NavigationrController是否隐藏;默认为YES）
 */
-(void)controlNavigationrControllerHiddenBySDK:(BOOL)bControl;
/**
 @brief 设置识别视频流质量
 @param sessionPreset 视频流质量
 */
-(void)setQuadRecoSessionPreset:(NSString *)sessionPreset;

/**
@brief 是否使用反光的错误提示

@param bReflective 默认为YES，使用反光错误提示；设置为NO时，不使用反光的错误提示
*/
-(void)setReflectivetTips:(BOOL)bReflective;
#pragma mark - 静态图片识别
/**
 通用四边定位静态识别
 
 @param image 传入证件图片
 @param cardType 卡证类型
 @param completedBlock 识别完成回调，获取识别结果EXOCRQuadCardInfo对象
 @param EXOCRFailedBlock 识别失败回调
 */
-(void)recoQuadCardFromStillImage:(UIImage *)image
                       OnCardType:(EXOCRCardType)cardType
                      OnCompleted:(EXOCRCompletedQuadCardBlock)completedBlock
                         OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;
/**
 特定证件四边定位静态识别（只支持身份证、行驶证、驾驶证）

 @param image 传入证件图片
 @param cardType 卡证类型
 @param completedBlock 识别完成回调，获取识别结果EXOCRQuadCardInfo对象
 @param particularCompletedBlock 识别完成回调，获取识别结果对象(不同cardType返回不同类型的对象)
 @param EXOCRFailedBlock 识别失败回调
 */
-(void)recoQuadCardFromStillImage:(UIImage *)image
                       OnCardType:(EXOCRCardType)cardType
                      OnCompleted:(EXOCRCompletedQuadCardBlock)completedBlock
            OnParticularCompleted:(EXOCRCompletedQuadCardParticularBlock)particularCompletedBlock
                         OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;

#pragma mark - 默认扫描视图
/**
 调用四边定位客户端识别

 @param cardType 要识别卡的类型
 @param completedBlock 识别完成回调，获取识别结果EXOCRQuadCardInfo对象
 @param EXOCRCanceledBlock 识别取消回调
 @param EXOCRFailedBlock 识别失败回调
 */
-(void)recoQuadCardFromStreamWithCardType:(EXOCRCardType)cardType
                              OnCompleted:(EXOCRCompletedQuadCardBlock)completedBlock
                               OnCanceled:(EXOCRCanceledBlock)EXOCRCanceledBlock
                                 OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;

/**
 特定证件四边定位客户端识别(身份证、行驶证、驾驶证)
 
 @param cardType 要识别卡的类型(目前只支持身份证、行驶证、驾驶证)
 @param completedBlock 识别完成回调，获取识别结果对象(不同cardType返回不同类型的对象)
 @param EXOCRCanceledBlock 识别取消回调
 @param EXOCRFailedBlock 识别失败回调
 */
-(void)recoQuadCardParticularFromStreamWithCardType:(EXOCRCardType)cardType
                              OnParticularCompleted:(EXOCRCompletedQuadCardParticularBlock)completedBlock
                                         OnCanceled:(EXOCRCanceledBlock)EXOCRCanceledBlock
                                           OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;

/**
 * @brief 扫描页设置，是否开启本地相册识别
 * @param bEnablePhotoRec - 默认为YES
 */
-(void)setEnablePhotoRec:(BOOL)bEnablePhotoRec;

/**
 扫描页设置，相册识别是否返回原图
 
 @param bOriginalImage 默认为NO
 */
-(void)setPhotoRecoOriginalImage:(BOOL)bOriginalImage;

/**
 扫描页设置，是否在光线较暗时开启闪光灯（仅在默认扫描视图中有效）

 @param bAutoFlash 默认为YES
 */
-(void)setAutoFlash:(BOOL)bAutoFlash;

/**
 * @brief 扫描页设置，是否显示logo
 * @param bDisplayLogo - 默认为YES
 */
-(void)setDisplayLogo:(BOOL)bDisplayLogo;

/**
 设置图像错误提示文字颜色

 @param tipColor 文字颜色
 */
-(void)setImageErrorTipColor:(UIColor *)tipColor;

/**
 设置图像错误提示文字字体

 @param fontName 字体名称
 @param fontSize 字体大小
 */
-(void)setImageErrorTipFontName:(NSString *)fontName fontSize:(float)fontSize;

#pragma mark - 自定义扫描视图
/**
 *	@brief 设置自定义扫描视图，当前版本仅身份证、行驶证、驾驶证（若自定义扫描视图，其他扫描页设置接口将无效）
 *         自定义扫描视图frame须与竖屏屏幕大小一致
 *         建议：自定义扫描视图frame设置为[UIScreen mainScreen].bounds(须保证width小于height)
 *  @return YES-设置自定义扫描视图成功，NO-设置自定义扫描视图失败
 *  @param customScanView - 自定义扫描试图
 */
-(BOOL)setCustomScanView:(UIView *)customScanView;

/**
 暂停识别（仅在设置自定义扫描视图成功后生效）
 
 @param bShouldStop 是否暂停视频流（默认为NO）
 */
-(void)pauseRecoWithStopStream:(BOOL)bShouldStop;

/**
 继续识别（仅在设置自定义扫描视图成功后生效）
 */
-(void)continueReco;
/**
继续识别时，设置的默认超时时间是否有效（仅在设置自定义扫描视图成功后生效）
 
@param bAble 默认超时时间是否有效（默认为NO）
*/
-(void)recoTimeoutWithContinueReco:(BOOL)bAble;

/**
 *	@brief 退出扫描识别控制器（仅在设置自定义扫描视图成功后生效）
 */
-(void)dismissScanViewControllerAnimated:(BOOL)animated;

/**
 *	@brief 闪光灯开启与关闭（仅在设置自定义扫描视图成功后生效）
 *  @param bMode - 闪光灯模式，YES-打开闪光灯，NO-关闭闪光灯
 */
-(void)setFlashMode:(BOOL)bMode;

/**
 * @brief 调用扫描识别(若默认扫描视图，请使用recoQuadCardParticularFromStreamWithCardType:OnParticularCompleted:OnCanceled:OnFailed:方法调用识别)
 */
-(void)recoQuadCardFromStreamByCustomScanViewWithCardType:(EXOCRCardType)cardType;

/**
 返回一张当前帧的图片

 @return 当前的帧图片,在识别成功的回调里调用，返回当前识别成功的原图
 */
- (UIImage*)getCurrentImage;

@end
