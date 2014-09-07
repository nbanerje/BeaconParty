//
//  OMDFirstViewController+Extras.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/6/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "OMDFirstViewController+Extras.h"


@implementation OMDFirstViewController (Extras)

-(IBAction)tappedButtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
