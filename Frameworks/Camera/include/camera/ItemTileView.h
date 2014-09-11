//
//  ItemTileView.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/4/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackItem.h"

@interface ItemTileView : UIView



-(void)createView;



@property (strong) PackItem                         *item;

@property bool                                      isSelected;

@property bool                                      isInteractive;

@end
