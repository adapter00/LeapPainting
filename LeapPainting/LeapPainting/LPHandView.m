//
//  LeapPantingHandView.m
//  LeapPainting
//
//  Created by takao maeda on 2014/03/30.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LPHandView.h"
#import "LPNotification.h"
#import "LPDictionaryKey.h"
#import "LeapObjectiveC.h"

@interface LPHandView (){
    BOOL isTracking;
    CGContextRef context;
    NSPoint palmPoint;
}
@property  LeapHand *trackingHand;

@end

@implementation LPHandView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        context = [[NSGraphicsContext currentContext] graphicsPort];
    }
    return self;
}

-(id)initWithTrakcingId:(int)trackingId{
    self = [super init];
    if (self) {
        // Initialization code here.
        context = [[NSGraphicsContext currentContext] graphicsPort];
        _TrakingId = trackingId;
    }
    return self;
}

-(void)StartTracking{
    [self drawPalm];
    [self drawFingers];
}

-(void)Tracking :(LeapHand *)hand{
    if(_trackingHand ==nil || [_trackingHand id] != [hand id]){
        _trackingHand = hand;
    }
    [self drawPalm];
    [self drawFingers];
    NSLog(@"drawing");
}
-(void)FinishTracking:(LPHand *)hand{
    
}

-(void)drawPalm{
//    palmPoint.x = [[_trackingHand palmPosition]x];
//    palmPoint.y = [[_trackingHand palmPosition]y];
    palmPoint.x = self.frame.origin.x/2;
    palmPoint.y = self.frame.origin.y/2;

    CGContextAddArc(context, palmPoint.x, palmPoint.y, 50, 0, 3.1415*2.0, 0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [[NSColor blackColor] CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, 1.0f);
    CGContextStrokePath(context);
    [self displayIfNeeded];
}

-(void)drawFingers{
        NSArray *fingetPoints=_trackingHand.fingers;
        NSBezierPath *bezierPath = [NSBezierPath bezierPath];
        for(int i = 0 ; i<fingetPoints.count; i++){
            LeapFinger *finger = fingetPoints[i];
            [self drawFinger:finger Bezier:bezierPath];
        }
}
-(void)drawFinger :(LeapFinger *)finger Bezier:(NSBezierPath *)bezierPath{
    LeapVector *vector=finger.tipPosition;
    //指先のPoint
    NSPoint tipPoint;
    tipPoint.x = vector.x;
    tipPoint.y = vector.y;
    [bezierPath moveToPoint:tipPoint];
    [bezierPath lineToPoint:palmPoint];
    [[NSColor grayColor] setStroke];
    [bezierPath setLineWidth:2.0f];
    [bezierPath stroke];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
