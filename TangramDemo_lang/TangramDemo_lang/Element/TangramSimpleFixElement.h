//
//  TangramSimpleFixElement.h
//  TangramDemo_lang
//
//  Created by jessie on 2017/12/28.
//  Copyright © 2017年 langzu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TangramElementHeightProtocol.h"
#import "TMMuiLazyScrollView.h"
#import "TangramEasyElementProtocol.h"
@interface TangramSimpleFixElement : UIControl<TangramElementHeightProtocol,TMMuiLazyScrollViewCellProtocol,TangramEasyElementProtocol>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, weak) TangramBus *tangramBus;
@property (nonatomic, weak) TangramDefaultItemModel *tangramItemModel;
@property (nonatomic, weak) UIView<TangramLayoutProtocol> *atLayout;
@end
