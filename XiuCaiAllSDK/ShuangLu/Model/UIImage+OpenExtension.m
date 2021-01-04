//
//  UIImage+OpenExtension.m
//  Open2.0
//
//  Created by Young on 16/11/2016.
//  Copyright © 2016 Young. All rights reserved.
//

#import "UIImage+OpenExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage(OpenExtension)

+(UIImage*)openImageName:(NSString*)imageName{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *imageName1 = [@"/XYZQOpenResource.bundle" stringByAppendingPathComponent:imageName];
    NSString *filePath = [[bundle bundlePath] stringByAppendingString:imageName1];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];//; [UIImage imageNamed:imageName
   return image;
}


-(UIImage *)scaleToSize:(CGSize)nSize
{
    UIGraphicsBeginImageContext(nSize);
    CGRect imageRect = CGRectMake(0.0, 0.0,nSize.width,nSize.height);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)scaleToSizeWithMaxWidthORHeight:(CGFloat)maxWidthOrHeight{
    UIImage *newImage1;
    CGFloat newWidth ;
    CGFloat newHeigh;
    if((self.size.width>maxWidthOrHeight) || (self.size.height>maxWidthOrHeight)){
        if(self.size.width>self.size.height){
            newWidth = maxWidthOrHeight;
            newHeigh =newWidth *self.size.height/self.size.width;
        }
        else{
            newHeigh = maxWidthOrHeight;
            newWidth =newHeigh *self.size.width/self.size.height;
            
        }
        newImage1 = [self scaleToSize:CGSizeMake(newWidth, newHeigh)];
        return newImage1;
    }
    else{
        return self;
    }
}

//
//
// 图片压缩
+(NSData*) ImageSizeReducerUnder50K:(UIImage*)originalImage{
    NSData *imageData;
    CGFloat ratio = 1.0;
    do{
        imageData = UIImageJPEGRepresentation(originalImage,ratio);
        CGFloat imageSize = [imageData length]/1024;
        if(imageSize <50) break;
        else{
            if(imageSize>500){
                if(ratio>=0.5){
                    ratio -= 0.5;
                }
                else{
                    break;
                }
                
            }
            else{
                if(ratio>=0.25){
                    ratio -= 0.25;
                }
                else{
                    break;
                }
                
            }
            
        }
    }while (1) ;
    
    return imageData;
    
}

+(NSData *)compressFromImage:(UIImage *)originImage{
    if(originImage==nil)return nil;
    CGFloat maxUploadSize = 50 * 1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.01f;
    
    NSData *imageData = UIImageJPEGRepresentation(originImage, compression);
    
    while ([imageData length] > maxUploadSize && compression > maxCompression) {
        compression -= 0.05;
        imageData = UIImageJPEGRepresentation(originImage, compression);
//        NSLog(@"Compress: %lu", (unsigned long)imageData.length);
    }
    
    return imageData;
}

+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    // fix mem leak
    CGImageRelease(newImageRef);
    return newImage;
}

@end
