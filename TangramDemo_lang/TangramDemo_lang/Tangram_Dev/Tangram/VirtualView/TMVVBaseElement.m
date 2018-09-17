//
//  TMVVBaseElement.m
//  Pods
//
//  Created by nigel on 2017/5/17.
//
//
#import "VVTempleteManager.h"
#import "TMVVBaseElement.h"
#import "TMUtils.h"
#import "UIView+VirtualView.h"
#import "TangramEvent.h"
#import "UIView+Tangram.h"

static BOOL xmlIsLoad = NO;

@interface TMVVBaseElement ()<VirtualViewDelegate, TMMuiLazyScrollViewCellProtocol>{
    //
}
@property(assign, nonatomic)BOOL    appear;
@end

@implementation TMVVBaseElement

+ (void)initVirtualViewSystem{
    [VVTempleteManager sharedInstance];
}

- (id)init{
    self = [super init];
    if (self) {
        if (xmlIsLoad==NO) {
            [TMVVBaseElement initVirtualViewSystem];
            xmlIsLoad = YES;
        }
    }
    return self;
}

- (void)calculateLayout
{
    ///self.itemModel.type
    self.frame = CGRectMake(floor(self.left), floor(self.top), floor(self.width), floor(self.height));
    if (self.contentView==nil) {
        self.contentView = (VVViewContainer*)[[VVViewFactory shareFactoryInstance] obtainVirtualWithKey:self.tangramItemModel.type];//11,1024
        self.contentView.delegate = self;
        [self addSubview:self.contentView];
    }
    NSUInteger w = self.frame.size.width;
    NSUInteger h = self.frame.size.height;
    self.contentView.frame = CGRectMake(0, 0, w, h);
    [self.contentView update:self.tangramItemModel.privateOriginalDict];
}

- (void)subViewClicked:(NSString*)action andValue:(NSString *)value
{
    NSString *actualAction = value;
    if (actualAction.length <= 0) {
        actualAction = [self.tangramItemModel bizValueForKey:action];
    }

    if (self.tangramBus) {
        TangramEvent *event = [[TangramEvent alloc]initWithTopic:TangramEventTopicJumpAction withTangramView:self.inTangramView posterIdentifier:@"singleImage" andPoster:self];
        [event setParam:action forKey:@"action"];
        
        [self.tangramBus postEvent:event];
    }
}
- (void)subViewLongPressed:(NSString*)action andValue:(NSString*)value gesture:(UILongPressGestureRecognizer *)gesture
{
    
}
+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel
{
    CGFloat ratio = [[VVTempleteManager sharedInstance]ratioByElementType:itemModel.type];
    if(ratio > 0.f)
    {
        return itemModel.itemFrame.size.width / ratio;
    }
    return [[VVTempleteManager sharedInstance]heightByElementType:itemModel.type];
}

+ (NSString *)reuseIdByModel:(TangramDefaultItemModel *)itemModel
{
    NSString *version = [[VVTempleteManager sharedInstance]localVersionByElementType:itemModel.type];
    return [NSString stringWithFormat:@"%@_%@",itemModel.type,version];
}

-(void)mui_afterGetView
{
    [self calculateLayout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
