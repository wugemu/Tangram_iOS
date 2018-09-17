//
//  TangramImageTextElement.h
//  TangramDemo_lang
//
//  Created by jessie on 2018/1/12.
//  Copyright © 2018年 langzu. All rights reserved.
//

#import <UIkit/UIkit.h>
#import "TangramElementHeightProtocol.h"
#import "TMMuiLazyScrollView.h"
#import "TangramDefaultItemModel.h"
#import "TangramEasyElementProtocol.h"

@interface TangramImageTextElement : UIControl<TangramElementHeightProtocol,TMMuiLazyScrollViewCellProtocol,TangramEasyElementProtocol>

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *action;

@property (nonatomic, weak) TangramDefaultItemModel *tangramItemModel;

@property (nonatomic, weak) UIView<TangramLayoutProtocol> *atLayout;

@property (nonatomic, weak) TangramBus *tangramBus;

@end
