//
//  LeapPantingHandView.h
//  LeapPainting
//
//  Created by takao maeda on 2014/03/30.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LeapObjectiveC.h"
@class LPHand;

@protocol LPTrackingControl <NSObject>

-(void)Tracking:(LPHand *)hand;

-(void)FinishTracking:(LPHand *)hand;

@end


@interface LPHandView : NSView<LPTrackingControl>
@property int TrakingId;

-(id)initWithTrakcingId:(int)trackingId;
-(void)Tracking :(LeapHand *)hand;

@end
