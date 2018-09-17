//
//  UIImage+scale.h
//  TXDS_Refactor
//
//  Created by SookinMac05 on 14-5-21.
//  Copyright (c) 2014年 sookin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

- (UIImage *)scaleTo:(CGSize)newSize;
//添加图片水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;

//带有边框的圆形头像。
-( UIImage *)getEllipseImageWithImage:( UIImage *)originImage;

//按形状切割图像
- (UIImage*)cutImageWithRadius:(int)radius;
+ (UIImage *)placeholderImageWithSize:(CGSize)size;

@end
