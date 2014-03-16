//
//  AppDelegate.h
//  LeapPainting
//
//  Created by takao maeda on 2014/02/11.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>



@property (assign) IBOutlet NSWindow *window;


-(void)globalMousemoved:(NSEvent *)event;


@end
