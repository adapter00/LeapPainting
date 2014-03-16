//
//  AppDelegate.m
//  LeapPainting
//
//  Created by takao maeda on 2014/02/11.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "AppDelegate.h"
#import "PaintingView.h"

@interface AppDelegate (){
    NSWindowController *_preferencesPanelController;
    NSWindowController *_graphicsInspectorController;
    NSWindowController *_gridInspectorController;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    PaintingView *view = [[PaintingView alloc] initWithFrame:CGRectMake(0, 0, [_window frame].size.width, [_window frame].size.height)];
    [_window setContentView:view];
//    [NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMoved handler:^(NSEvent *event){
//        [self globalMousemoved:event];
//        return event;
//    }];
}


-(void)globalMousemoved:(NSEvent *)event{
    //左下原点のマウス座標を取得
    CGEventRef eventRef = CGEventCreate(NULL);
    CGPoint point = CGEventGetLocation(eventRef);
    //CGEventRefの解放
    CFRelease(eventRef);
    //ログ表示
    NSLog(@"LocalMouseMoved : x = %f ,y = %f",point.x,point.y);
}

@end
