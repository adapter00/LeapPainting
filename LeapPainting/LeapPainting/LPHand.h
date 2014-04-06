//
//  LeapPaintingHand.h
//  LeapPainting
//
//  Created by takao maeda on 2014/03/30.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

typedef enum{
    LPUnkwnown = 0,
    LPRightHand = 1,
    LPLeftHand = 2
}LPHandness;


@interface LPHand : NSObject{
    LPHandness handness;
}

@property LeapHand *hand;
@property NSPoint handPoint;
@property NSPoint palmCenterPotision;
@property NSArray *fingers;
@property BOOL isTracking;
@property int trackingId;

+(LPHandness)whichHand:(LeapHand*)hand;

-(id)initWithHand:(LeapHand *)hand;
-(void)MoveHand:(LeapHand *)hand;

@end
