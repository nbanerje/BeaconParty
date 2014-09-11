//
//  PhotoPaginator.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/13/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Photo.h"
#import "PhotoFrame.h"

@protocol PhotoPaginatorDelegate

@optional

-(void)didTapPhoto:(UIImage *)image;

@end

@interface PhotoPaginator : UIView <UIScrollViewDelegate, PhotoFrameDelegate>
{
    id                                              delegate;
    UIScrollView                                    *scrollView;
}


-(void)createView:(NSArray *)photos;

-(void)createNavIndicators:(int)count;

-(void)loadPhotos;

@property (strong) id<PhotoPaginatorDelegate>       delegate;

@end
