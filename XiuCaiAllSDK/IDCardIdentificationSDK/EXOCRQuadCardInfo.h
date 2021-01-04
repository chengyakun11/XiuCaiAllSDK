//
//  EXOCRQuadCardInfo.h
//  quadcard
//
//  Created by 肖尧 on 17/2/14.
//  Copyright © 2017年 肖尧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief 取图模式码
 *
 *	@discussion 用于设置取图模式，目前仅对身份证识别生效
 */
#define QUAD_IMAGEMODE_LOW         (0)        //原始图像
#define QUAD_IMAGEMODE_MEDIUM      (1)        //严格切边
#define QUAD_IMAGEMODE_HIGH        (2)        //严格切边并留白
/**
 *	@brief 四边定位卡证识别回调状态码
 *
 *	@discussion 识别回调中获取状态码
 */
#define QUAD_CODE_SUCCESS               (0)
#define QUAD_CODE_CANCEL                (1)
#define QUAD_CODE_RECO_FAIL             (-1)
#define QUAD_CODE_FAIL_TIMEOUT          (-2)
#define QUAD_CODE_XML_FAIL              (-3)
#define QUAD_CODE_FAIL_NOTSUPPORT       (-4)
#define QUAD_CODE_INITFAIL              (-5)

@interface EXOCRQuadCardInfo : NSObject

@property (strong, nonatomic) NSString *cardType;           //卡证类型
@property (assign, nonatomic) int pageType;                 //1为正面，2为反面
@property (assign, nonatomic) int hasShadow;                //当前仅对身份证识别有效；1为有遮挡，0为无遮挡；遮挡主要是针对手持身份证时造成的手指遮挡,存在误判率
@property (strong, nonatomic) NSMutableArray *itemArray;    //识别数据(EXOCRQuadCardInfoItem数组)
@property (strong, nonatomic) UIImage *cardImg;             //卡证截图
@property (strong, nonatomic) UIImage *faceImg;             //人脸截图
@property (strong, nonatomic) UIImage *originalImg;         //识别的原图
@property (assign, nonatomic) BOOL isFromStream;            //识别结果来源，YES为视频流识别结果，NO为静态图片识别结果

- (NSString *)toString;

@end
