//
//  LeaListner.m
//  LeapPainting
//
//  Created by takao maeda on 2014/03/22.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LeapListner.h"
#include <ApplicationServices/ApplicationServices.h>

@interface LeapListner(){
    //現在のhandId
    int handId;
    //Leapで追跡する手を認識しているか
    BOOL handIsSet;
}

@property LeapController *controller;
@end

@implementation LeapListner

//ここでLeapMotionとの接続を完了させておく(基本はNSNotificationから通知されてくる)
-(void)run{
    _controller=[[LeapController alloc] init];
    [_controller addListener:self];
    NSLog(@"LeapMotionSetting完了♪(・ω<)");
}

-(void)onInit:(NSNotification *)notification{
    NSLog(@"LeapMotionDelegateの登録が完了したよ");
}

-(void)onConnect:(NSNotification *)notification{
    LeapController *aController= (LeapController *)[notification object];
    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
    NSLog(@"LeapMotion接続が完了したよ");
}

-(void)onDisconnect:(NSNotification *)notification{
    NSLog(@"LeapMotionとの接続を解除したよ");
}

-(void)onExit:(NSNotification *)notification{
    NSLog(@"LeapMotionから離脱");
}


-(void)onFrame:(NSNotification *)notification{
    LeapController *aController = (LeapController *)[notification object];
    LeapFrame *frame            = [aController frame:0];

    NSArray *screenList = [aController locatedScreens];
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
                CGEventRef mouse = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDragged, CGPointMake(x, y), 0);
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
