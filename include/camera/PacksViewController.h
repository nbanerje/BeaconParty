//
//  PacksViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/28/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "PackWorker.h"
#import "Pack.h"
#import "PackItemsViewController.h"

#import "PackItemView.h"

#import "GAITrackedViewController.h"

@interface PacksViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *packs;
    
    UITableView *tableView;
    
    IBOutlet UILabel* screenTitle;
}

@property (strong) IBOutlet UITableView *tableView;

@end
