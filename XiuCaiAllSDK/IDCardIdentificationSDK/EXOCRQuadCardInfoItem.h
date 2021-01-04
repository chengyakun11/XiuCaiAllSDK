//
//  EXOCRQuadCardInfoItem.h
//  quadcard
//
//  Created by 肖尧 on 17/2/14.
//  Copyright © 2017年 肖尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXOCRQuadCardInfoItem : NSObject

//条目编号
@property (assign, nonatomic) int ItemID;
//名称
@property (strong, nonatomic) NSString *KeyWord;
//结果
@property (strong, nonatomic) NSString *OCRText;
//边框
@property (strong, nonatomic) NSString *rect;

@end
