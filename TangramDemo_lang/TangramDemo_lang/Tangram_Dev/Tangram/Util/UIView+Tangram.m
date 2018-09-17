//
//  UIView+Tangram.m
//  Tangram
//
//  Copyright (c) 2015-2017 alibaba. All rights reserved.
//

#import "UIView+VirtualView.h"
#import "TangramView.h"


@implementation UIView (Tangram)

- (TangramView *)inTangramView
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        if ([next isKindOfClass:[TangramView class]]) {
            return (TangramView *)next;
        }
    }
    return nil;
}

@end
