//
//  PackTileView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/4/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Pack.h"

@protocol PackTileViewDelegate

-(void)packTileViewTouchEnded:(Pack *)pack;

@end

@interface PackTileView : UIImageView
{
    id                                              delegate;
    Pack                                            *pack;
}


@property (strong) id<PackTileViewDelegate>         delegate;
@property (strong) Pack                             *pack;

@end
