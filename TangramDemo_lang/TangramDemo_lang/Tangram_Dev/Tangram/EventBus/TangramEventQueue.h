//
//  TangramEventQueue.h
//  Tangram
//
//  Copyright (c) 2016-2017 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TangramEvent;


@interface TangramEventQueue : NSObject

/**
 * The length of the event queue.
 */
- (NSUInteger)length;

/**
 * Add a event to queue.
 */
- (void)pushEvent:(nonnull TangramEvent *)event;

/**
 * Get a event.
 */
- (nullable TangramEvent *)popEvent;

@end
