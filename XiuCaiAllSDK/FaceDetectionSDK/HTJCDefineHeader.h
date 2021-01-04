//
//  HTJCDefineHeader.h
//  HTJCFaceLiveDetectSdk
//
//  Created by TBoys on 2017/3/13.
//  Copyright © 2017年 hisign. All rights reserved.
//

#ifndef HTJCDefineHeader_h
#define HTJCDefineHeader_h

typedef enum HTJCMovementType{
    KeepStill,		// 0(注视)
    ShakeHead,		// 1(摇头)
    NodHead,		// 2(点头)
    OpenMouth, 		// 3(张嘴)
    BlinkEye,		// 4(眨眼)
    MovePhone,      // 5(上下晃动手机 暂不可用)
    Idle,           // 6(无动作监测中,存在于动作切换之间, 可单独设置该动作只做引导采集照片)
}HTJCMovementType;

typedef enum HTJCReturnValue{
    FacePass           = 101,//人脸通过
    FaceNoLocation     = 102,//不在人脸框内
    FaceNotSingle      = 103,//多人脸
    FaceNull           = 104,//无人脸
    LightTooDark       = 105,//光线过暗
    LightTooBright     = 106,//光线过亮
    VerticalPhone      = 107,//竖直手机
}HTJCReturnValue;

//引导时 HTJCReturnValue 是无人脸/不在人脸框 达到30帧 则播放提示音
#define GUIDE_VOICE_DELAY_FRAME           30

#pragma mark
#pragma mark - ERROR_CODE

#define HTJC_ERR_NONE								0           //没有错误
#define HTJC_ERR_BREAK                          -1000           //检测被中断/取消
#define HTJC_ERR_GUIDETIMEOUT                   -1001           //引导超时
#define HTJC_ERR_NOFACE                         -1002           //检测中无人脸
#define HTJC_ERR_NOTSINGLE                      -1003           //多人脸
#define HTJC_ERR_NOTLIVE                        -1004           //非活体(暂时不可用)
#define HTJC_ERR_MOVEMENT                       -1005           //动作(互斥)错误
#define HTJC_ERR_DETECTTIMEOUT                  -1006           //检测超时
#define HTJC_ERR_NOPICTURE                      -1007           //照片获取失败
#define HTJC_ERR_3DSTRUCTURE                    -1008           //3D 错误
#define HTJC_ERR_SKINCOLOR                      -1009           //肤色错误
#define HTJC_ERR_CONTINUE                       -1010           //连续性错误
#define HTJC_ERR_OPERATIONERROR                 -1011           //非常规操作
#define HTJC_ERR_INITFAIL                       -1012           //SDK初始化失败
#define HTJC_ERR_AUTHEXPIRE                     -1013           //SDK授权过期
#define HTJC_ERR_CAMERA                         -1014           //相机打开失败
#define HTJC_ERR_SDERROR                        -1015           //SD卡无法读取(暂时不可用)

#endif /* HTJCDefineHeader_h */
