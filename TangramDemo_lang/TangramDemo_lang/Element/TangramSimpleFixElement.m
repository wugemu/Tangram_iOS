//
//  TangramSimpleFixElement.m
//  TangramDemo_lang
//
//  Created by jessie on 2017/12/28.
//  Copyright © 2017年 langzu. All rights reserved.
//

#import "TangramSimpleFixElement.h"
#import "TangramEvent.h"
#import "UIView+Tangram.h"

@interface TangramSimpleFixElement()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *label;

@end
@implementation TangramSimpleFixElement
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

- (UILabel *)label
{
    if (nil == _label) {
        _label = [[UILabel alloc]init];
        [self addSubview:_label];
    }
    return _label;
}
- (void)mui_afterGetView
{
    self.backgroundColor=[UIColor redColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.label.text = self.text;
    self.label.textAlignment=NSTextAlignmentCenter;
    self.label.textColor=[UIColor yellowColor];
}

+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel
{
    return 60.f;
}

- (void)clickedOnElement
{
    TangramEvent *event = [[TangramEvent alloc]initWithTopic:@"jumpAction" withTangramView:self.inTangramView posterIdentifier:@"singleImage" andPoster:self];
    [event setParam:self.action forKey:@"action"];
    [self.tangramBus postEvent:event];
}
@end
