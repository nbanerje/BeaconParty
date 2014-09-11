//
//  FilterScrollView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/19/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol FilterScrollViewDelegate

-(void)didSelectFilter:(int)filter;

@end

@interface FilterScrollView : UIView
{
    id                                                  delegate;
    UIScrollView                                        *scrollView;
}

-(void)createView;

-(void)disableButtons;

-(void)enableButtons;


@property (strong) id<FilterScrollViewDelegate>         delegate;

@end
