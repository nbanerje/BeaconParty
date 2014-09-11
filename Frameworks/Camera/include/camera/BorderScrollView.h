//
//  BorderScrollView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 3/27/12.
//  Copyright (c) 2012 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@protocol BorderScrollViewDelegate

-(void)didSelectBorder:(int)border;

@end

@interface BorderScrollView : UIView
{
    id                                                  delegate;
    UIScrollView                                        *scrollView;
}

-(void)createView;

-(void)disableButtons;

-(void)enableButtons;


@property (strong) id<BorderScrollViewDelegate>         delegate;

@end
