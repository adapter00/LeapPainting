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
}

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
    }
    return self;
}

-(void)mouseDragged:(NSEvent *)theEvent{
    NSPoint point = [theEvent locationInWindow];
    if(prePoint.x != 0 && prePoint.y != 0){
         [self drawLine:prePoint EndPoint:point];
    }
    prePoint =point;
}

-(void)moudDraggedWithLeap{}

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
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

@end
