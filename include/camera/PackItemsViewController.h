//
//  PackItemsViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/4/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "Pack.h"
#import "PackItem.h"
#import "ItemTileView.h"
#import "AppDelegate.h"
#import "InAppPurchaseManager.h"

@protocol PackItemsViewControllerDelegate

-(void)didFinishPickingItems:(NSArray *)items;

@end

@interface PackItemsViewController : UIViewController
{
    Pack    *pack;
    UIScrollView    *scrollView;
    
    UIActivityIndicatorView *activityIndicator;
}

-(void)createTopBar;
-(void)createTiles;

@property (strong) id<PackItemsViewControllerDelegate>  delegate;
@property (strong) Pack *pack;
@property bool  isIAPView;

@end
