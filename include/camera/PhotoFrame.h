//
//  PhotoFrame.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/13/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Photo.h"
#import "AsyncPhotoView.h"

#import "UIImage+Resize.h"

@protocol PhotoFrameDelegate

@optional

-(void)didTapPhoto:(UIImage *)image;

@end

@interface PhotoFrame : UIView <AsyncPhotoViewDelegate>
{
    id                                          delegate;
    AsyncPhotoView                              *photoView;
    Photo                                       *photo;
    
    UIView                                      *bgView;
}

-(id)initWithPhoto:(Photo *)p andFrame:(CGRect)frame;

-(void)createView:(Photo *)p;

-(void)loadImageFromPhoto;

@property (strong) id<PhotoFrameDelegate>       delegate;

@end
