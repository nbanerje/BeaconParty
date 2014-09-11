//
//  AsyncPhotoView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/13/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Photo.h"
#import "PhotoRaw.h"

#import "UIImage+Resize.h"

@protocol AsyncPhotoViewDelegate

@optional

-(void)asyncImageViewDidFinishLoading:(UIImageView *)view;

@end


@interface AsyncPhotoView : UIImageView
{
    UIImage                                         *originalImage;
}

-(void)loadImageFromPhoto:(Photo *)p;
-(void)loadPhotoAsync:(Photo *)p;
-(void)createImageView:(UIImage *)img;


@property (strong) id <AsyncPhotoViewDelegate>      delegate;

@end
