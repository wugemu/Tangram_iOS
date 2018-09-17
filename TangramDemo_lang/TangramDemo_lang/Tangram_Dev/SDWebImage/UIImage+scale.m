//
//  UIImage+scale.m
//  TXDS_Refactor
//
//  Created by SookinMac05 on 14-5-21.
//  Copyright (c) 2014年 sookin. All rights reserved.
//

#import "UIImage+scale.h"

@implementation UIImage (scale)

//图片缩放
- (UIImage *)scaleTo:(CGSize)size
//(float)scaleSize
{
	UIGraphicsBeginImageContextWithOptions(size,NO,[[UIScreen mainScreen] scale]);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return scaledImage;
}

//添加图片水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSData * data = UIImagePNGRepresentation(newPic);
//    UIImage * img = [UIImage imageWithData:data];
    
    return newPic;
}


//带有边框的圆形头像。
-( UIImage *)getEllipseImageWithImage:( UIImage *)originImage

{
    
    CGFloat padding = 0 ; // 圆形图像距离图像的边距
    
    UIColor * epsBackColor = [ UIColor clearColor]; // 图像的背景色
    
    CGSize originsize = originImage. size ;
    
    CGRect originRect = CGRectMake ( 0 , 0 , originsize. width , originsize. height );
    
    UIGraphicsBeginImageContext (originsize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext ();
    
    // 目标区域。
    
    CGRect desRect =  CGRectMake (padding, padding,originsize. width -(padding* 2 ), originsize. height -(padding* 2 ));
    
    // 设置填充背景色。
    
    CGContextSetFillColorWithColor (ctx, epsBackColor. CGColor );
    
    UIRectFill (originRect); // 真正的填充
    
    // 设置椭圆变形区域。
    
    CGContextAddEllipseInRect (ctx,desRect);
    
    CGContextClip (ctx); // 截取椭圆区域。
    
    [originImage drawInRect :originRect]; // 将图像画在目标区域。
    
    // 边框 //
    
    CGFloat borderWidth = 10 ;
    
    CGContextSetStrokeColorWithColor (ctx, [ UIColor whiteColor ]. CGColor ); // 设置边框颜色
    
    CGContextSetLineCap (ctx, kCGLineCapButt );
    
    CGContextSetLineWidth (ctx, borderWidth); // 设置边框宽度。
    
    CGContextAddEllipseInRect (ctx, desRect); // 在这个框中画圆
    
    CGContextStrokePath (ctx); // 描边框。
    
    // 边框 //
    
    UIImage * desImage = UIGraphicsGetImageFromCurrentImageContext (); // 获取当前图形上下文中的图像。
    
    UIGraphicsEndImageContext ();
    
    return desImage;
    
}




//图片剪切
- (UIImage*)cutImageWithRadius:(int)radius
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+self.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+self.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, self.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}
+ (UIImage *)placeholderImageWithSize:(CGSize)size {
    
    // 占位图的背景色
    UIColor *backgroundColor = [UIColor whiteColor];
    // 中间LOGO图片
    UIImage *image = [UIImage imageNamed:@"goods_placeholder"];
    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resImage;
    
}


@end
