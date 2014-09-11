//
//  OverlayImage.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/14/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OverlayImage : UIView
{
    UIImage                                 *originalImage;
    UIView                                  *bgView;
    UIImageView                             *imgView;
    
    bool                                    isSelected;
    bool                                    isFlipped;
    float                                   currentRotation;
    float                                   scale;
}

-(void)createViewWithImage:(UIImage *)img;

-(void)transformSelfAndSubviews:(CGAffineTransform)transform;

-(void)transform:(float)degrees;

-(void)setSelected;

-(void)setUnselected;


-(UIImage *)getImage;


@property bool                              isSelected;
@property bool                              isFlipped;

@property float                             scale;

@property (strong) UIImage                  *originalImage;
@property (strong) UIImageView              *imgView;

@end
