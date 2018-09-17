//
//  AppTools.m
//  netmodel
//
//  Created by Never More on 13-5-21.
//  Copyright (c) 2013年 protend. All rights reserved.
//

#import "AppTools.h"
#import "MBProgressHUD.h"


@interface AppTools()



@end

@implementation AppTools

+ (id)shareInstance
{
    static dispatch_once_t once;
    Class class = [self class];
    static AppTools* instance;
    dispatch_once(&once, ^{
        instance = [[class alloc]init];
    });
    
    return instance;
}



/*
 显示吐司
 */
+(void)showToastUseMBHub:(UIView *)view showText:(NSString *)text{

    if ([text isKindOfClass:[NSNull class]]||text==nil||[text isEqualToString:@""]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
//    hud.labelText = text;
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.yOffset = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
    
}


@end
