//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"
#import "YYAnimationIndicator.h"

@interface MJDIYHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UISwitch *s;
@property (weak, nonatomic) UIImageView *logo;
@property (strong, nonatomic) YYAnimationIndicator *loading;
@end

@implementation MJDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 90;
    self.backgroundColor = mainWhiteColor;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"cbcbcb"];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // logo
    UIImageView * logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    logoImg.image = LOCAL_IMAGE(@"load1.png");
    [self addSubview:logoImg];
    self.logo = logoImg;
    
    
    // loading
    self.loading = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.loading setLoadText:@""];
    [self addSubview:self.loading];
    [self.loading setHidden:YES];
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.label.frame = CGRectMake(self.mj_w/2 - 100, 45, 200, 20);
    self.logo.center = CGPointMake(self.mj_w/2, 30);
    self.loading.center = CGPointMake(self.mj_w/2, 35);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            if([self.loading isAnimating])
            {
                [self.loading stopAnimationWithLoadText:@"" withType:YES];
                self.logo.hidden = NO;
            }
            self.label.text = @"正在楼顶(loading)看风景";
            break;
        case MJRefreshStatePulling:
            if([self.loading isAnimating])
            {
                [self.loading stopAnimationWithLoadText:@"" withType:YES];
                self.logo.hidden = NO;
            }
            self.label.text = @"正在楼顶(loading)看风景";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在楼顶(loading)看风景";
            if(![self.loading isAnimating]) {
                self.logo.hidden = YES;
                [self.loading startAnimation];
            }
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.label.textColor = [UIColor colorWithHexString:@"cbcbcb"];
}

@end
