//
//  LPViewController.m
//  LeapPainting
//
//  Created by takao maeda on 2014/04/05.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LPViewController.h"
#import "CanvasView.h"
#import "LeapListner.h"
#import "LeapPaintingController.h"
#import "LPNotification.h"
#import "LPHandView.h"
#import "LPDictionaryKey.h"


@interface LPViewController (){
    NSView *overlayHandView;
    LPHandView *handView;
    LeapPaintingController *controller;
}

@end

@implementation LPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)loadView{
    
    [super loadView];
    [self LPViewControllerViewDidLoad];
}

-(void)LPViewControllerViewDidLoad{
    CanvasView *canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height)];
    [self.view addSubview:canvasView];
    overlayHandView= [[NSView alloc] initWithFrame:[self.view frame]];
    [self.view addSubview:overlayHandView positioned:NSWindowAbove relativeTo:self.view];
    [self run];
}

-(void)run {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(Tracking:) name:LPLeapPaintginViewUpdate object:nil];
    handView =[[LPHandView alloc] initWithFrame:self.view.frame];
    [overlayHandView addSubview:handView];
    [handView Tracking:nil];
}

-(void)Tracking :(NSNotification *) notificatoin{
    NSLog(@"Leapからの通信であります(ﾟ∀ﾟ)");
    LeapHand *hand = [[notificatoin userInfo] objectForKey:LPHandKey];
    [handView Tracking:hand];
}

@end
