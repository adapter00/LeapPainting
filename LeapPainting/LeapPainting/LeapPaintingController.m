//
//  LeapPaintgingViewController.m
//  LeapPainting
//
//  Created by takao maeda on 2014/03/30.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LeapPaintingController.h"
#import "LPHand.h"
#import "LPHandView.h"
#import "LPNotification.h"
#import "LPDictionaryKey.h"


@interface LeapPaintingController (){
    //現在のhandId
    int handId;
    //Leapで追跡する手を認識しているか
    BOOL handIsSet;
    NSNotification *notify;
}
@property LeapController *controller;
@property LPHand *rightHand;
@property LPHand *leftHand;
@property LPHandView *rightHandView;
@property LPHandView *leftHandView;

@end

@implementation LeapPaintingController

-(void)run{
    _controller=[[LeapController alloc] init];
    [_controller addListener:self];
    NSLog(@"Setting Finish");
}


-(void)onInit:(NSNotification *)notification{
    NSLog(@"LeapMotionDelegateの登録が完了したよ");
}

-(void)onConnect:(NSNotification *)notification{
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
    NSArray *hands=[frame hands];
        LeapHand *hand = [hands objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:hand forKey:LPHandKey];
        notify = [NSNotification notificationWithName:LPLeapPaintginViewUpdate object:self userInfo:dic];
//        notify = [NSNotification notificationWithName:LPLeapPaintginViewUpdate object:self];
//        [[NSNotificationCenter defaultCenter] postNotification:notify];
}


@end
