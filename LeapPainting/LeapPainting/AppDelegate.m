//
//  AppDelegate.m
//  LeapPainting
//
//  Created by takao maeda on 2014/02/11.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "AppDelegate.h"
#import "LPViewController.h"
#import "LeapPaintingController.h"

@interface AppDelegate (){
    LeapPaintingController *controller;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    LPViewController *viewController= [[LPViewController alloc] initWithNibName:@"LPViewController" bundle:nil];
    [_window setContentView:viewController.view];
    controller = [[LeapPaintingController alloc] init];
    [controller run];
}

@end
