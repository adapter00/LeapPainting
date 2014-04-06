//
//  PaintingView.m
//  LeapPainting
//
//  Created by takao maeda on 2014/03/09.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "PaintingView.h"

@interface PaintingView (){
    CGMutablePathRef path;
    CGContextRef context;
    NSPoint prePoint;
    CGColorRef kLineColor;
    float kLineWidth;
    //現在のhandId
    int handId;
    //Leapで追跡する手を認識しているか
    BOOL handIsSet;
    BOOL isTracking;
}

@property LeapController *controller;

@end

@implementation PaintingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        context = [[NSGraphicsContext currentContext] graphicsPort];
        kLineColor = [[NSColor blackColor] CGColor];
        kLineWidth = 5.0f;
        NSTrackingArea* trackingArea_ = [[NSTrackingArea alloc] initWithRect:[self bounds] options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow ) owner:self userInfo:nil];
        [self addTrackingArea:trackingArea_];
    }
    [self run];
    return self;
}



-(void) mouseEntered:(NSEvent *)theEvent{
    isTracking = YES;
    [[self window] setAcceptsMouseMovedEvents:YES];
}


-(void)mouseMoved:(NSEvent *)theEvent{
    NSPoint point = [theEvent locationInWindow];
    if(isTracking){
        if(prePoint.x != 0 && prePoint.y != 0){
            [self drawLine:prePoint EndPoint:point];
        }
        prePoint =point;
    }else{
        prePoint.x = 0;
        prePoint.y = 0;
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    NSLog(@"exited");
    isTracking = NO;
    [[self window] setAcceptsMouseMovedEvents:NO];
}

-(void)changeLineColor :(NSColor*) color{
    kLineColor = [color CGColor];
}

-(void)changeLineWidth :(float)lineWidth{
    kLineWidth  =lineWidth;
}

//線を描く
-(void)drawLine :(NSPoint) startPoint EndPoint: (NSPoint)endPoint{
    CGContextMoveToPoint(context,prePoint.x,prePoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, kLineColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, 1.0f);
    CGContextStrokePath(context);
    [self displayIfNeeded];
    NSLog(@"Drawing");
}


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}


#pragma LeapDelegate

//ここでLeapMotionとの接続を完了させておく(基本はNSNotificationから通知されてくる)
-(void)run{
    _controller=[[LeapController alloc] init];
    [_controller addDelegate:self];
    NSLog(@"LeapMotionSetting完了♪(・ω<)");
}

-(void)onInit:(NSNotification *)notification{
    NSLog(@"LeapMotionDelegateの登録が完了したよ");
}

-(void)onConnect:(LeapController *)controller{
    [controller enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
    [controller enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [controller enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [controller enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
    NSLog(@"LeapMotion接続が完了したよ");
}

-(void)onDisconnect:(NSNotification *)notification{
    NSLog(@"LeapMotionとの接続を解除したよ");
}

-(void)onExit:(NSNotification *)notification{
    NSLog(@"LeapMotionから離脱");
}


-(void)onFrame:(LeapController *)controller{
    LeapFrame *frame            = [controller frame:0];
    
    NSArray *screenList = [controller locatedScreens];
    LeapScreen *mainScreen = screenList[0];
    NSArray *hands=[frame hands];
    if( hands.count != 0){
        LeapHand *leftHand;
        if(handIsSet){
            BOOL isSet = NO;
            for(int i = 0 ;i<hands.count; i++){
                LeapHand *tempHand = hands[i];
                if(tempHand.id == handId){
                    leftHand = tempHand;
                    isSet = YES;
                }
            }
            if(!isSet){
                leftHand = hands[0];
                if(hands.count>1){
                    for(int i = 1; i < hands.count; i++){
                        if([[hands[i] palmPosition] x] <[[leftHand palmPosition] x]){
                            leftHand = hands[i];
                        }
                    }
                }
            }
        } else {
            leftHand = hands[0];
            if (hands.count > 1) {
                for (int i = 1 ; i<hands.count; i++){
                    if([[hands[i] palmPosition] x] < [[leftHand palmPosition] x]){
                        leftHand = hands[i];
                    }
                }
            }
        }
        NSMutableArray *fingerUncordered = [[NSMutableArray alloc] init];
        NSMutableArray *fingersFromLeftToRight = [[NSMutableArray alloc] init];
        [fingerUncordered addObjectsFromArray:[leftHand fingers]];
        if(fingerUncordered.count > 0){
            while (fingerUncordered.count > 0){
                int selectedFinger = 0;
                LeapFinger *leftFinger = fingerUncordered[0];
                for(int i = 0; i<fingerUncordered.count ; i++){
                    if([[fingerUncordered[i] tipPosition]x] <= [[leftFinger tipPosition]x]){
                        leftFinger = fingerUncordered[i];
                        selectedFinger = i;
                    }
                }
                [fingersFromLeftToRight addObject:leftFinger];
                [fingerUncordered removeObjectAtIndex:selectedFinger];
            }
            LeapFinger *nearestFinger = fingersFromLeftToRight[0];
            for(int i = 1; i<fingersFromLeftToRight.count ; i++){
                LeapFinger *tempFinger = fingersFromLeftToRight[i];
                float tempDistance = [mainScreen distanceToPoint:tempFinger.tipPosition];
                float currenShortestDistance = [mainScreen distanceToPoint:nearestFinger.tipPosition];
                if(tempDistance < currenShortestDistance){
                    nearestFinger = tempFinger;
                }
            }
            if([nearestFinger isValid]){
                handIsSet = YES;
                handId = leftHand.id;
                LeapVector *screenFactors = [mainScreen
                                             intersect:[nearestFinger tipPosition]
                                             direction:[nearestFinger direction]
                                             normalize:YES
                                             clampRatio:1.0f];
                int x = screenFactors.x * [mainScreen widthPixels];
                int y = [mainScreen heightPixels] - (screenFactors.y * [mainScreen heightPixels]);
                CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
                CGEventRef mouse = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(x, y), 0);
                CGEventPost(kCGHIDEventTap, mouse);
                CFRelease(mouse);
                CFRelease(source);
            }
        }
    }
}

-(NSString *)stringForState:(LeapGestureState)state
{
    switch (state) {
        case LEAP_GESTURE_STATE_INVALID:
            return @"STATE_INVALID";
        case LEAP_GESTURE_STATE_START:
            return @"STATE_START";
        case LEAP_GESTURE_STATE_UPDATE:
            return @"STATE_UPDATED";
        case LEAP_GESTURE_STATE_STOP:
            return @"STATE_STOP";
        default:
            return @"STATE_INVALID";
    }
}


@end
