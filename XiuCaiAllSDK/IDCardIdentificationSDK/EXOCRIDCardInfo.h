//
//  EXOCRIDCardInfo.h
//  ExCardSDK
//
//  Created by kubo on 16/9/6.
//  Copyright (c) 2014年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief 身份证取图模式码
 *
 *	@discussion 用于设置身份证取图模式
 */
#define ID_IMAGEMODE_LOW         (0)        //原始图像
#define ID_IMAGEMODE_MEDIUM      (1)        //严格切边
#define ID_IMAGEMODE_HIGH        (2)        //严格切边并留白
/**
 *	@brief 身份证识别回调状态码
 *
 *	@discussion 识别回调中获取状态码
 */
#define ID_CODE_SUCCESS         (0)
#define ID_CODE_CANCEL          (1)
#define ID_CODE_FAIL            (-1)
#define ID_CODE_FAIL_TIMEOUT    (-2)
#define ID_CODE_INITFAIL        (-3)

/**
 *	@brief 身份证数据模型类
 */
@interface EXOCRIDCardInfo : NSObject

@property (nonatomic, assign) int type;             //1:人像面  2:国徽面

@property (nonatomic, strong) NSString *name;       //姓名
@property (nonatomic, strong) NSString *gender;     //性别
@property (nonatomic, strong) NSString *nation;     //民族
@property (nonatomic, strong) NSString *birth;      //出生
@property (nonatomic, strong) NSString *address;    //地址
@property (nonatomic, strong) NSString *code;       //身份证号

@property (nonatomic, strong) NSString *issue;      //签发机关
@property (nonatomic, strong) NSString *valid;      //有效期

@property (nonatomic, strong) UIImage *frontFullImg;//身份证正面全图
@property (nonatomic, strong) UIImage *backFullImg; //身份证背面全图
@property (nonatomic, strong) UIImage *originalImg; //身份证识别原图

@property (assign, nonatomic) int frontShadow; //1:正面图像有遮挡 0:正面图像无遮挡；遮挡主要是针对手持身份证时造成的手指遮挡,存在误判率
@property (assign, nonatomic) int backShadow; //1:背面图像有遮挡 0:背面图像无遮挡；遮挡主要是针对手持身份证时造成的手指遮挡,存在误判率

@property (assign, nonatomic) BOOL isFromStream;//识别结果来源，YES为视频流识别结果，NO为静态图片识别结果

@property (assign, nonatomic) int incomplete; //1:图片+留白超出了原图 0：图片正常,只有在留白模式下才会做判断，其他模式返回0
@property (assign, nonatomic) int imageMode;  //静态图片中切图时调用的切图模式，4为留白模式

@property (nonatomic, strong) UIImage *faceImg;         //人脸截图
@property (nonatomic, strong) UIImage *nameImg;         //姓名截图
@property (nonatomic, strong) UIImage *nameImgPadding;  //姓名截图(留白)
@property (nonatomic, strong) UIImage *sexImg;          //性别截图
@property (nonatomic, strong) UIImage *nationImg;       //民族截图
@property (nonatomic, strong) UIImage *addressImg;      //地址截图
@property (nonatomic, strong) UIImage *codeImg;         //身份证号截图
@property (nonatomic, strong) UIImage *codeImgPadding;  //身份证号截图（留白）

@property (nonatomic, strong) UIImage *issueImg;    //签发机关截图
@property (nonatomic, strong) UIImage *validImg;    //有效期截图

-(NSString *)toString;

@end
