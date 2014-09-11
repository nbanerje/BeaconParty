//
//  PackItemView.h
//  Hipster Christmas
//
//  Created by Chris Jorgensen on 11/21/13.
//  Copyright (c) 2013 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackItemView : UITableViewCell
{

}

@property (weak, nonatomic) IBOutlet UIImageView* avatar;
@property (weak, nonatomic) IBOutlet UILabel* name;
@property (weak, nonatomic) IBOutlet UILabel* count;
@property (weak, nonatomic) IBOutlet UILabel* price;

@end
