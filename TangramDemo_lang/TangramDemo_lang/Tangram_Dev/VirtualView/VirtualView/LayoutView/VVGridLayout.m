//
//  VVGridLayout.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVGridLayout.h"
@interface VVGridLayout (){

}
@end;

@implementation VVGridLayout
- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret = [ super setFloatValue:value forKey:key];
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_itemHeight:
                _itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                _itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                _itemVerticalMargin = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_colCount:
                _colCount = value;
                break;

            case STR_ID_itemHeight:
                _itemHeight = value;
                break;
            case STR_ID_itemHorizontalMargin:
                _itemHorizontalMargin = value;
                break;
            case STR_ID_itemVerticalMargin:
                _itemVerticalMargin = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    int index = 0;
    for (int row=0; row<_rowCount; row++) {
        for (int col=0; col<_colCount; col++) {
            if (index<self.subViews.count) {
                VVViewObject* vvObj = [self.subViews objectAtIndex:index];
                if(vvObj.visible==GONE){
                    continue;
                }
                CGFloat pX = self.frame.origin.x+(vvObj.width+self.itemHorizontalMargin)*col+self.paddingLeft+vvObj.marginLeft;
                CGFloat pY = self.frame.origin.y+(vvObj.height+self.itemVerticalMargin)*row+self.paddingTop+vvObj.marginTop;
                /*
                CGFloat blanceW = (_itemMaxSize.width-vvObj.width-vvObj.marginLeft-vvObj.marginRight)/2.0;
                CGFloat blanceH = (_itemMaxSize.height-vvObj.height-vvObj.marginTop-vvObj.marginBottom)/2.0;
                
                if((vvObj.layoutGravity&Gravity_H_CENTER)==Gravity_H_CENTER){
                    //
                    pX += blanceW<0?0:blanceW;
                }else if((vvObj.layoutGravity&Gravity_RIGHT)!=0){
                    pX = pX+blanceW*2;//(blanceW<0?0:blanceW)*2.0;
                }else{
                    pX += 0;
                }
                
                if((vvObj.layoutGravity&Gravity_V_CENTER)==Gravity_V_CENTER){
                    //
                    pY += blanceH<0?0:blanceH;
                }else if((vvObj.layoutGravity&Gravity_BOTTOM)!=0){
                    pY = pY+blanceH*2;//(blanceW<0?0:blanceW)*2.0;
                }else{
                    pY += 0;
                }*/
                
                vvObj.frame = CGRectMake(pX, pY, vvObj.width, vvObj.height);
                [vvObj layoutSubviews];
                index++;
            }else{
                break;
            }
        }
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    
    if (_colCount<1) {
        return CGSizeZero;
    }
    
    CGSize contentSize = maxSize;
    
    if (self.heightModle!=MATCH_PARENT && self.heightModle!=WRAP_CONTENT) {
        contentSize.height = self.heightModle;
    }
    
    if (self.widthModle!=MATCH_PARENT && self.widthModle!=WRAP_CONTENT) {
        contentSize.width = self.widthModle;
    }
    
    switch (self.autoDimDirection) {
        case AUTO_DIM_DIR_X:
             contentSize.height = contentSize.width*(self.autoDimY/self.autoDimX);
            
            break;
        case AUTO_DIM_DIR_Y:
             contentSize.width = contentSize.height*(self.autoDimX/self.autoDimY);
            break;
        default:
            break;
    }
    
    //CGFloat itemWidth = maxSize.width;
    CGFloat itemMaxHeight = _itemHeight;
    CGFloat itemMaxWidth = 0;
    CGFloat maxWidth=0,maxHeight=0;
    _rowCount = self.subViews.count/_colCount;
    if (self.subViews.count%_colCount>0) {
        _rowCount++;
    }
    //contentSize.width -= self.marginLeft+self.marginRight;
    //contentSize.height-= self.marginTop +self.marginBottom;
    if (_colCount>0) {
        itemMaxWidth = (contentSize.width-self.paddingLeft-self.paddingRight-self.itemHorizontalMargin*(_colCount-1))/_colCount;
//        if (self.widthModle==WRAP_CONTENT || self.widthModle==MATCH_PARENT) {
//            itemMaxWidth = (contentSize.width-self.paddingLeft-self.paddingRight)/_colCount;
//        }else{
//            itemMaxWidth = (self.widthModle-self.paddingLeft-self.paddingRight)/_colCount;
//        }
    }else{
        return CGSizeZero;
    }
    
    if (_itemHeight==0 && _rowCount>0) {
        _itemHeight = itemMaxHeight = (contentSize.height-self.paddingTop-self.paddingBottom-self.itemVerticalMargin*(_rowCount-1))/_rowCount;
//        if (self.heightModle==WRAP_CONTENT || self.heightModle==MATCH_PARENT){
//            itemMaxHeight = (maxSize.height-self.paddingTop-self.paddingBottom)/_rowCount;
//        }else{
//            itemMaxHeight = (self.heightModle-self.paddingTop-self.paddingBottom)/_rowCount;
//        }
    }
    
    _itemMaxSize = CGSizeMake(itemMaxWidth, itemMaxHeight);
    
    for (int index =0; index<self.subViews.count; index+=_colCount) {
        CGFloat tmpWidth=0,tmpHeight=0;
        for (int j=0; j<_colCount; j++) {
            if (index+j==self.subViews.count) {
                break;
            }
            VVViewObject* vvObj = [self.subViews objectAtIndex:index+j];
            CGSize itemSize = [vvObj calculateLayoutSize:_itemMaxSize];
            #ifdef VV_DEBUG
                NSLog(@"h:%f,w:%f",itemSize.height,itemSize.width);
            #endif
            tmpWidth+=itemSize.width;
            tmpHeight=itemSize.height;
        }
//        maxWidth = maxWidth<tmpWidth?tmpWidth:maxWidth;
//        maxHeight= maxHeight<tmpHeight?tmpHeight:maxHeight;
        maxWidth = tmpWidth;
        maxHeight += tmpHeight;
    }
    maxWidth += self.itemHorizontalMargin*(_colCount-1);
    maxHeight += self.itemVerticalMargin*(_rowCount-1);
    switch ((int)self.widthModle) {
        case WRAP_CONTENT:
            //
            self.width = self.paddingRight+self.paddingLeft+maxWidth;
            break;
        case MATCH_PARENT:
            self.width = maxSize.width - self.marginLeft - self.marginRight;
            
            break;
        default:
            self.width = self.widthModle;
            break;
    }
    
    switch ((int)self.heightModle) {
        case WRAP_CONTENT:
            //
            self.height = self.paddingTop+self.paddingBottom+maxHeight;
            break;
        case MATCH_PARENT:
            self.height = maxSize.height - self.marginTop - self.marginBottom;
            
            break;
        default:
            self.height = self.heightModle;
            break;
    }
    //[self autoDim];
    //return CGSizeMake(self.width, self.height);
    return CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
}
@end
