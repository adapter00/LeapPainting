//
//  LPWindowController.m
//  LeapPainting
//
//  Created by takao maeda on 2014/04/05.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LPWindowController.h"

@interface LPWindowController ()

@end

@implementation LPWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        CanvasView *view = [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, [window frame].size.width, [window frame].size.height)];
        controller = [[LeapPaintingViewController alloc] initWithController];

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
