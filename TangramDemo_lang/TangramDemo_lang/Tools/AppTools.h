//
//  AppTools.h
//  netmodel
//
//  Created by Never More on 13-5-21.
//  Copyright (c) 2013年 protend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppTools : NSObject{

}

+ (id)shareInstance;

+(void)showToastUseMBHub:(UIView *)view showText:(NSString *)text;


@end
