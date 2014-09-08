//
//  EffectsViewController.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *fastStrobeButton;
@property (weak, nonatomic) IBOutlet UIButton *slowStrobeButton;
@property (weak, nonatomic) IBOutlet UIButton *rainbowFadeButton;
@property (weak, nonatomic) IBOutlet UIButton *audioSyncButton;
- (IBAction)action:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *rainbowView;

@end
