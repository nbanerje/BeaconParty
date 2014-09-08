//
//  OMDImageDetailViewController.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 12/22/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDMediaObject.h"
#import "GAITrackedViewController.h"
@interface OMDImageDetailViewController : GAITrackedViewController
@property (nonatomic,strong) IBOutlet UIImageView *imageDetail;
@property (nonatomic,strong) IBOutlet UIProgressView *progress;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic,strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic,strong) OMDMediaObject *obj;

@end
