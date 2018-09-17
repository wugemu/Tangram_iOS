//
//  VVPageView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVPageView.h"
#import "VVBinaryLoader.h"
#import "VVViewFactory.h"
#import "VVViewContainer.h"
#import "NVCarouselPageView.h"

@interface VVPageView ()<UIScrollViewDelegate>
@property(strong, nonatomic)CALayer*   drawLayer;
@property(strong, nonatomic)NVCarouselPageView * scrollView;

@property(strong, nonatomic) NSArray *data;
@end


@implementation VVPageView

- (id)init{
    self = [super init];
    if (self) {
        self.scrollView = [[NVCarouselPageView alloc] init];
        self.cocoaView = _scrollView;
    }
    return self;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
                case STR_ID_stayTime:
                break;
                case STR_ID_autoSwitchTime:
                break;
                case STR_ID_animatorTime:
                break;
                default:
                break;
        }
    }
    return ret;
}

- (BOOL)setStringValue:(int)value forKey:(int)key{
    BOOL ret = [super setStringValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
                case STR_ID_autoSwitch:
                break;
                case STR_ID_canSlide:
                break;
                default:
                break;
        }
    }
    return ret;
}

- (BOOL)setExprossValue:(int)value forKey:(int)key{
    BOOL ret = [super setExprossValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_onPageFlip:
                //
                break;
            default:
                break;
        }
    }
    return ret;
}

- (int)getValue4Array:(NSArray*)arr{
    int value=0;
    for (NSString* item in arr) {
        if ([item compare:@"left" options:NSCaseInsensitiveSearch]) {
            value=value|Gravity_LEFT;
        }else if ([item compare:@"right" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_RIGHT;
        }else if ([item compare:@"h_center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_H_CENTER;
        }else if ([item compare:@"top" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_TOP;
        }else if ([item compare:@"bottom" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_BOTTOM;
        }else if ([item compare:@"v_center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_V_CENTER;
        }else if ([item compare:@"center" options:NSCaseInsensitiveSearch]){
            value=value|Gravity_H_CENTER|Gravity_V_CENTER;
        }
    }
    return value;
}

- (NSString*)valueForVariable:(id)obj fromJsonData:(NSDictionary*)jsonData{
    
    NSString* valueObj = nil;
    
    if ([obj isKindOfClass:NSArray.class]) {
        NSDictionary* tmpDictionary = jsonData;
        //NSString* varName = nil;
        NSArray* varList = (NSArray*)obj;
        for (NSDictionary* varItem in varList) {
            NSString* varName = [varItem objectForKey:@"varName"];
            int index = [[varItem objectForKey:@"varIndex"] intValue];

            if (index>=0) {
                NSArray* items = [tmpDictionary objectForKey:varName];
                if (items.count>index) {
                    valueObj = [items objectAtIndex:index];
                }else{
                    valueObj = @"";
                }
            }else{
                valueObj = [tmpDictionary objectForKey:varName];
            }

            if ([valueObj isKindOfClass:NSDictionary.class]) {
                tmpDictionary = (NSDictionary*)valueObj;
            }

        }
    }else{
        NSString* varString = (NSString*)obj;
        NSRange startPos = [varString rangeOfString:@"${"];
        if (startPos.location==NSNotFound) {
            return varString;
        }

        NSRange endPos   = [varString rangeOfString:@"}" options:NSCaseInsensitiveSearch range:NSMakeRange(startPos.location, varString.length-startPos.location)];

        if (endPos.location==NSNotFound) {
            return varString;
        }

        if (startPos.location!=NSNotFound && endPos.location!=NSNotFound && endPos.location>startPos.location) {
            NSString* key = [varString substringWithRange:NSMakeRange(startPos.location+2, endPos.location-startPos.length)];
            valueObj = [jsonData objectForKey:key];
        }
    }

    return valueObj;
}

- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    //
    NSMutableArray* dataTagObjs = nil;
    VVViewContainer* vvContainer = nil;
    if([[self superview].updateDelegate isKindOfClass:VVViewContainer.class]){
        vvContainer = (VVViewContainer*)[self superview].updateDelegate;
        dataTagObjs = vvContainer.dataTagObjs;
    }
    [self resetObj];
    NSArray* dataArray = (NSArray*)obj;
    self.data = dataArray;
//    for (NSDictionary* jsonData in dataArray) {
//        //
//        NSString* widget=[jsonData objectForKey:@"type"];
//        NSMutableArray* updateObjs = [[NSMutableArray alloc] init];
//        VVViewObject* vv = [[VVViewFactory shareFactoryInstance] parseWidgetWithTypeID:widget collection:updateObjs];
//        //[vv calculateLayoutSize:size];
//        for (VVViewObject* item in updateObjs) {
//            [item reset];
//            for (NSNumber* key in [item.mutablePropertyDic allKeys]) {
//                NSDictionary* propertyInfo = [item.mutablePropertyDic objectForKey:key];
//                //NSString* varName = [propertyInfo objectForKey:@"varName"];
//                NSNumber* valueType = [propertyInfo objectForKey:@"valueType"];
//                NSArray* varObj = [propertyInfo objectForKey:@"varValues"];
//                
//                //NSArray* nodes = [varName componentsSeparatedByString:@"."];
//                NSObject* valueObj = nil;
//                NSDictionary* tmpDictionary = jsonData;
//                NSString* varName = nil;
//                if([varObj isKindOfClass:NSArray.class]){
//                    for (NSDictionary* varItem in varObj) {
//                        NSString* var = [varItem objectForKey:@"varName"];
//                        int index = [[varItem objectForKey:@"varIndex"] intValue];
//                        if (index>=0) {
//                            NSArray* items = [tmpDictionary objectForKey:var];
//                            if (items.count>index) {
//                                valueObj = [items objectAtIndex:index];
//                            }else{
//                                valueObj = @"";
//                            }
//                        }else{
//                            valueObj = [tmpDictionary objectForKey:var];
//                        }
//
//                        if ([valueObj isKindOfClass:NSDictionary.class]) {
//                            tmpDictionary = (NSDictionary*)valueObj;
//                        }
//
//                        varName = var;
//                    }
//                }else if ([varObj isKindOfClass:NSString.class]){
//                    valueObj = [tmpDictionary objectForKey:varObj];
//                    varName = (NSString*)varObj;
//                }
//                /*for (NSString* node in nodes) {
//                    //NSLog(@"%@",node);
//                    NSRange start = [node rangeOfString:@"["];
//                    NSRange end   = [node rangeOfString:@"]"];
//                    if (start.location!=NSNotFound && end.location!=NSNotFound && start.location<end.location) {
//                        NSRange indexRange = NSMakeRange(start.location+1, end.location-start.location-1);
//                        NSString* indexString = [node substringWithRange:indexRange];
//                        NSUInteger index = [indexString integerValue];
//                        NSString* nodeName = [node substringToIndex:start.location];
//                        NSArray* items = [tmpDictionary objectForKey:nodeName];
//                        if (items.count>index) {
//                            valueObj = [items objectAtIndex:index];
//                        }else{
//                            valueObj = @"";
//                        }
//                    }else{
//                        valueObj = [tmpDictionary objectForKey:node];
//                    }
//                    
//                    if ([valueObj isKindOfClass:NSDictionary.class]) {
//                        tmpDictionary = (NSDictionary*)valueObj;
//                    }
//                }*/
//                
//                int keyValue = [key intValue];
//                
//                switch ([valueType intValue]) {
//                    case TYPE_INT:
//                    {
//                        int value=0;
//                        if ([propertyInfo allValues].count>2) {
//                            NSObject* objValue;
//                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                objValue = [propertyInfo objectForKey:@"v1"];
//                            }else{
//                                objValue = [propertyInfo objectForKey:@"v2"];
//                            }
//                            value = [[self valueForVariable:objValue fromJsonData:jsonData] intValue];
//                        }else{
//                            value = [(NSNumber*)valueObj intValue];
//                        }
//                        [item setIntValue:value forKey:keyValue];
//                        
//                    }
//                        break;
//                    case TYPE_FLOAT:
//                    {
//                        CGFloat value=0;
//                        if ([propertyInfo allValues].count>2) {
//                            NSObject* objValue;
//                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                objValue = [propertyInfo objectForKey:@"v1"];
//                            }else{
//                                objValue = [propertyInfo objectForKey:@"v2"];
//                            }
//                            value = [[self valueForVariable:objValue fromJsonData:jsonData] floatValue];
//                        }else{
//                            value = [(NSNumber*)valueObj floatValue];
//                            [item setFloatValue:value forKey:keyValue];
//                        }
//                        
//                        [item setFloatValue:value forKey:keyValue];
//                    }
//                        break;
//                    case TYPE_STRING:
//                    {
//                        NSString* value=@"";
//                        if ([propertyInfo allValues].count>2) {
//                            if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                value = [propertyInfo objectForKey:@"v1"];
//                            }else{
//                                value = [propertyInfo objectForKey:@"v2"];
//                            }
//                        }else{
//                            value = (NSString*)valueObj;
//                        }
//                        value = [self valueForVariable:value fromJsonData:jsonData];
//                        [item setStringDataValue:value forKey:keyValue];
//                    }
//                        break;
//                    case TYPE_COLOR:
//                    {
//                        {
//                            NSString* value=@"";
//                            if ([propertyInfo allValues].count>2) {
//                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                    value = [propertyInfo objectForKey:@"v1"];
//                                }else{
//                                    value = [propertyInfo objectForKey:@"v2"];
//                                }
//                            }else{
//                                value = (NSString*)valueObj;
//                            }
//                            value = [self valueForVariable:value fromJsonData:jsonData];
//                            [item setStringDataValue:value forKey:keyValue];
//                        }
//                        break;
//                    case TYPE_BOOLEAN:
//                        {
//                            NSString* value=@"";
//                            if ([propertyInfo allValues].count>2) {
//                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                    value = [propertyInfo objectForKey:@"v1"];
//                                }else{
//                                    value = [propertyInfo objectForKey:@"v2"];
//                                }
//                            }else{
//                                value = (NSString*)valueObj;
//                            }
//                            
//                            value = [self valueForVariable:value fromJsonData:jsonData];
//                            if ([value isEqualToString:@"true"]) {
//                                [item setIntValue:1 forKey:[key intValue]];
//                            }else{
//                                [item setIntValue:0 forKey:[key intValue]];
//                            }
//                        }
//                        
//                        break;
//                    case TYPE_VISIBILITY:
//                        {
//                            NSString* value=@"";
//                            if ([propertyInfo allValues].count>2) {
//                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                    value = [propertyInfo objectForKey:@"v1"];
//                                }else{
//                                    value = [propertyInfo objectForKey:@"v2"];
//                                }
//                            }else{
//                                value = (NSString*)valueObj;
//                            }
//                            
//                            value = [self valueForVariable:value fromJsonData:jsonData];
//                            if ([value isEqualToString:@"invisible"]) {
//                                [item setIntValue:INVISIBLE forKey:[key intValue]];
//                            }else if([value isEqualToString:@"visible"]) {
//                                [item setIntValue:VISIBLE forKey:[key intValue]];
//                            }else{
//                                [item setIntValue:GONE forKey:[key intValue]];
//                            }
//                        }
//                        
//                        break;
//                    case TYPE_GRAVITY:
//                        {
//                            NSString* value=@"";
//                            if ([propertyInfo allValues].count>2) {
//                                if (((NSString*)valueObj).length>0 && [(NSString*)valueObj isEqualToString:@"false"]==NO) {
//                                    value = [propertyInfo objectForKey:@"v1"];
//                                }else{
//                                    value = [propertyInfo objectForKey:@"v2"];
//                                }
//                            }else{
//                                value = (NSString*)valueObj;
//                            }
//                            value = [self valueForVariable:value fromJsonData:jsonData];
//                            [item setIntValue:[self getValue4Array:[value componentsSeparatedByString:@"|"]] forKey:keyValue];
//                        }
//                        
//                        break;
//                    case TYPE_OBJECT:
//                        [item setDataObj:[jsonData objectForKey:varName] forKey:keyValue];
//                        break;
//                    default:
//                        break;
//                    }
//                }
//                //[item setDataObj:(NSDictionary*)obj];
//            }
//        }
//        
//       // [self addSubview:vv];
//        
//    }
    self.updateDelegate = (id<VVWidgetAction>)vvContainer;
    [self attachCocoaViews:self];
    if (self.scrollView.superview==nil) {
        [vvContainer addSubview:self.scrollView];
    }
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    //[[super ].updateDelegate setUpdateDelegate:delegate];
    for (VVViewObject* subObj in self.subViews) {
        subObj.updateDelegate = (id<VVWidgetAction>)self.scrollView;
    }
//    if (self.drawLayer==nil) {
//        self.drawLayer = [CALayer layer];
//        self.drawLayer.drawsAsynchronously = YES;
//        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
//        self.drawLayer.delegate =  (id<CALayerDelegate>)self;
//        //[((UIView*)self.updateDelegate).layer addSublayer:self.drawLayer];
//        [self.scrollView.layer insertSublayer:self.drawLayer atIndex:0];
//    }
}

- (void)attachCocoaViews:(VVViewObject*)vvObj{
//    for (VVViewObject* subView in vvObj.subViews) {
//        [self attachCocoaViews:subView];
//        if (subView.cocoaView) {
//            [self.scrollView addSubview:subView.cocoaView];
//        }
//    }
}

- (void)removeCocoaView:(VVViewObject*)vvObj{
    
//    NSArray* subViews = [NSArray arrayWithArray:vvObj.subViews];
//    for (VVViewObject* item in subViews) {
//        [self removeCocoaView:item];
//    }
//    
//    if (vvObj.cocoaView) {
//        [vvObj.cocoaView removeFromSuperview];
//    }
    //[vvObj removeFromSuperview];
}

- (void)resetObj{
//    NSArray* subViews = [NSArray arrayWithArray:self.subViews];
//    for (VVViewObject* subView in subViews) {
//        [self removeCocoaView:subView];
//        [subView removeFromSuperview];
//    }
    
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    CGSize itemsSize={0,0};
    CGFloat maxWidth=0.0, maxHeight = 0.0;
    
    if (self.heightModle!=MATCH_PARENT && self.heightModle!=WRAP_CONTENT) {
        maxSize.height = self.height;
    }
    
    if (self.widthModle!=MATCH_PARENT && self.widthModle!=WRAP_CONTENT) {
        maxSize.width = self.width;
    }
    
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            maxSize.height = maxSize.height = maxSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case AUTO_DIM_DIR_Y:
            maxSize.width = maxSize.width = maxSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    
    CGFloat blanceWidth = maxSize.width-self.paddingLeft-self.paddingRight, blanceHeight = maxSize.height-self.paddingTop-self.paddingBottom;
    
    int matchWidthType=0,matchHeightType=0;
    
    for (VVViewObject* item in self.subViews) {
        if(item.visible==GONE){
            continue;
        }
        matchWidthType = item.widthModle;
        matchHeightType = item.heightModle;
        CGSize toItemSize={0,0};
        switch (self.orientation) {
            case VERTICAL:
                if (item.widthModle==MATCH_PARENT && self.widthModle==WRAP_CONTENT) {
                    //continue;
                    toItemSize.width = maxSize.width;//maxWidth;
                }else/* if (item.widthModle==WRAP_CONTENT)*/{
                    toItemSize.width = maxSize.width;
                }
                toItemSize.height = blanceHeight;
                break;
            default:
                if (item.heightModle==MATCH_PARENT && self.heightModle==WRAP_CONTENT) {
                    //continue;
                    toItemSize.height = maxSize.height;//maxHeight;
                }else/* if (item.heightModle==WRAP_CONTENT)*/{
                    toItemSize.height = maxSize.height;
                }
                toItemSize.width = blanceWidth;
                break;
        }
        toItemSize.height-=item.marginTop+item.marginBottom;
        toItemSize.width -=item.marginLeft+item.marginRight;
        CGSize size = [item calculateLayoutSize:toItemSize];
        if (self.orientation==VERTICAL) {
            //blanceHeight -= size.height;
            itemsSize.height+=size.height+item.marginTop+item.marginBottom;
            self.childrenHeight = itemsSize.height;
            
            if (matchWidthType==WRAP_CONTENT) {
                maxWidth = maxWidth<size.width?size.width:maxWidth;
                self.childrenWidth = maxWidth;
            }else if (matchWidthType==MATCH_PARENT && self.widthModle!=WRAP_CONTENT){
                self.childrenWidth = maxWidth = maxSize.width;
            }else{
                self.childrenWidth = maxWidth =maxWidth<size.width?size.width:maxWidth;
            }
        }else{
            //blanceWidth -= size.width;
            itemsSize.width+=size.width+item.marginLeft+item.marginRight;
            self.childrenWidth = itemsSize.width;
            
            if (matchHeightType==WRAP_CONTENT) {
                maxHeight = maxHeight<size.height?size.height:maxHeight;
                self.childrenHeight = maxHeight;
            }else if (matchHeightType==MATCH_PARENT && self.heightModle!=WRAP_CONTENT){
                self.childrenHeight = maxHeight = maxSize.height;
            }else{
                self.childrenHeight = maxHeight = maxHeight<size.height?size.height:maxHeight;
            }
        }
    }
    
    //if (self.autoDimDirection==AUTO_DIM_DIR_X) {
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            //
            self.width = self.orientation==VERTICAL?maxWidth:itemsSize.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
        case MATCH_PARENT:
            self.width=maxSize.width;
            
            break;
        default:
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
    }
    //}
    
    self.width = self.width<maxSize.width?self.width:maxSize.width;
    //if (self.autoDimDirection==AUTO_DIM_DIR_Y) {
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            self.height= self.orientation==VERTICAL?itemsSize.height:maxHeight;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
        case MATCH_PARENT:
            self.height=maxSize.height;
            
            break;
        default:
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
    }
    //}
    
    self.height = self.height<maxSize.height?self.height:maxSize.height;
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
            self.height = self.width*(self.autoDimY/self.autoDimX);
            
            break;
        case AUTO_DIM_DIR_Y:
            self.width = self.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    //[self autoDim];
    
    return CGSizeMake(self.width, self.height);
}

- (void)layoutSubviews{
    NVCarouselPageView *pageView = (NVCarouselPageView*)self.cocoaView;
    pageView.frame = CGRectMake(0, 0, self.width, self.width);
    pageView.data = self.data;
    pageView.pageView = self;
    [pageView calculateLayout];
}


@end
