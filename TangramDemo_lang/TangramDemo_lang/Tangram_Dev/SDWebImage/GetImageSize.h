//
//  GetImageSize.h
//  FarmShopping
//
//  Created by unispeed on 15/12/9.
//  Copyright © 2015年 PenG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImageSize : NSObject

//单例类
+ (id)getImageInstance;

-(CGSize)downloadImageSizeWithURL:(id)imageURL;


@end
