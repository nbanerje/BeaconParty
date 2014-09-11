//
//  PackScrollView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/4/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PackWorker.h"
#import "Pack.h"
#import "PackTileView.h"

@protocol PackScrollViewDelegate

-(void)didSelectPack:(Pack *)pack;

@end

@interface PackScrollView : UIView <PackTileViewDelegate>
{
    NSArray                                             *packs;
    UIScrollView                                        *scrollView;
}

-(void)createView;


@property (strong) id<PackScrollViewDelegate>           delegate;


@end
