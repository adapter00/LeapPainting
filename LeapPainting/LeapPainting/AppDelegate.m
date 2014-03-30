//
//  AppDelegate.m
//  LeapPainting
//
//  Created by takao maeda on 2014/02/11.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "AppDelegate.h"
#import "PaintingView.h"
#import "LeapListner.h"

@interface AppDelegate (){
    LeapListner *lisnter;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    PaintingView *view = [[PaintingView alloc] initWithFrame:CGRectMake(0, 0, [_window frame].size.width, [_window frame].size.height)];
    [_window setContentView:view];
    lisnter = [[LeapListner alloc] init];
    [lisnter run];
}

@end
