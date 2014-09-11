//
//  TouchCameraView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/2/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WildcardGestureRecognizer.h"
#import "OverlayImage.h"
#import "PackScrollView.h"
#import "PackItem.h"

static inline CGFloat angleBetweenLinesInRadians(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) 
{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat line1Slope = (line1End.y - line1Start.y) / (line1End.x - line1Start.x);
    CGFloat line2Slope = (line2End.y - line2Start.y) / (line2End.x - line2Start.x);
    
    CGFloat degs = acosf(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return (line2Slope > line1Slope) ? degs : -degs;
}

@protocol TouchCameraViewDelegate<NSObject> 

-(void)multitouchMoved;

@optional

-(void)hasSelectedItem;

-(void)hasUnselectedItem;

@end

@interface TouchCameraView : UIView
{
    id <TouchCameraViewDelegate>                            delegate;
    bool                                                    isDragging;
    int                                                     currentTag;
    int                                                     itemCount;
    
    CGPoint                                                 lastPoint;
    CGPoint                                                 lastRotatePoint;
    float                                                   lastScaleDistance;
    float                                                   lastRotateDistance;
    
    PackScrollView                                          *packScrollView;
}

-(void)createView;

-(void)removeSelected;

-(void)duplicateSelected;

-(void)addLetterbox;

-(void)addBears;

-(void)addLuchador;

-(void)addMustache;

-(void)addPatrick;

-(void)addUnicorn;

-(void)addPBR;

-(void)addZappa:(int)num;

-(void)addItem:(PackItem *)item;

-(void)addPackScrollview;

@property (strong) id <TouchCameraViewDelegate>             delegate;

@property int                                               itemCount;

@end
