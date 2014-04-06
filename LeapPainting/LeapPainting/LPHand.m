//
//  LeapPaintingHand.m
//  LeapPainting
//
//  Created by takao maeda on 2014/03/30.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LPHand.h"
#import "LPNotification.h"
#import "LPDictionaryKey.h"

@interface LPHand (){
    BOOL handIsSet;
}

@end

@implementation LPHand

-(id)initWithHand : (LeapHand *)leapHand{
    if(self = [super init]){
        if(!handIsSet && leapHand.isValid){
            _hand =leapHand;
            _trackingId = leapHand.id;
            handIsSet = YES;
            _fingers  = leapHand.fingers;
        }
    }
    return  self;
}

-(void)MoveHand :(LeapHand *)hand{
    //ObserverでViewに通知(Viewが変更されました)
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self forKey:LPHandKey];
    NSNotification *notification = [NSNotification notificationWithName: LPLeapPaintginViewUpdate object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



@end
