//
//  PolaroidViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/28/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PolaroidViewControllerDelegate

-(void)didFinishAnimating;

@end

@interface PolaroidViewController : UIViewController
{
    id                                                      delegate;
    
    UIImageView                                             *background;
    UIImageView                                             *overlay;
}


@property (strong) id <PolaroidViewControllerDelegate>      delegate;

@end
