//
//  UIImage+OpenExtension.h
//  Open2.0
//
//  Created by Young on 16/11/2016.
//  Copyright © 2016 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(OpenExtension)

-(UIImage *)scaleToSize:(CGSize)nSize;

+(NSData*) ImageSizeReducerUnder50K:(UIImage*)originalImage;
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+(NSData *)compressFromImage:(UIImage *)originImage;
-(UIImage*)scaleToSizeWithMaxWidthORHeight:(CGFloat)maxWidthOrHeight;
+(UIImage*)openImageName:(NSString*)imageName;
@end
