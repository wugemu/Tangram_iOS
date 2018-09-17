//
//  TangramImageTextElement.m
//  TangramDemo_lang
//
//  Created by jessie on 2018/1/12.
//  Copyright © 2018年 langzu. All rights reserved.
//

#import "TangramImageTextElement.h"
#import "UIImageView+WebCache.h"
#import "TangramEvent.h"
#import "UIView+Tangram.h"
@interface TangramImageTextElement()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TangramImageTextElement
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addTarget:self action:@selector(clickedOnElement) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
    }
    return self;
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        self.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font=FONT(12);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(void)setImgUrl:(NSString *)imgUrl
{
    if (imgUrl.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.width > 0 && frame.size.height > 0) {
        [self mui_afterGetView];
    }
}

- (void)mui_afterGetView
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.titleLabel.frame = CGRectMake(0, self.imageView.bounds.size.height+5, self.frame.size.width, 10);
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.text = @"商品名称";
}

- (void)clickedOnElement
{
    TangramEvent *event = [[TangramEvent alloc]initWithTopic:@"jumpAction" withTangramView:self.inTangramView posterIdentifier:@"singleImage" andPoster:self];
    [event setParam:self.action forKey:@"action"];
    [self.tangramBus postEvent:event];
}


+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel;
{
    return 100.f;
}
@end
