//
//  YYAnimationIndicator.m
//  AnimationIndicator
//
//  Created by 王园园 on 14-8-26.
//  Copyright (c) 2014年 王园园. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "YYAnimationIndicator.h"

@implementation YYAnimationIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.7;
        _isAnimating = NO;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,10, frame.size.width-30,frame.size.height-30)];
        [self addSubview:imageView];
        //设置动画帧
        imageView.animationImages=[NSArray arrayWithObjects: [UIImage imageNamed:@"load1.png"],
                                   [UIImage imageNamed:@"load2.png"],
                                   [UIImage imageNamed:@"load3.png"],
                                   [UIImage imageNamed:@"load4.png"],
                                   [UIImage imageNamed:@"load5.png"],
                                   nil ];
        
        
        Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.textAlignment = NSTextAlignmentCenter;
        Infolabel.textColor = mainGrayColor;
//        Infolabel.textColor = [UIColor colorWithRed:84.0/255 green:86./255 blue:212./255 alpha:1];
//        Infolabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:12.0f];
        Infolabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:Infolabel];
        self.layer.hidden = YES;
    }
    return self;
}


- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

-(void)doAnimation{
    
    Infolabel.text = _loadtext;
    //设置动画总时间
    imageView.animationDuration=0.6;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"load1.png"]];
    }
    
}


-(void)setLoadText:(NSString *)text;
{
    if(text){
        _loadtext = text;
    }
}

@end
