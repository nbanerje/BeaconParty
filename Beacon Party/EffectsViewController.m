//
//  EffectsViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "EffectsViewController.h"
#import "OMDTorch.h"
#define FAST_TORCH_FREQ 40.0
#define SLOW_TORCH_FREQ 4.0
@interface EffectsViewController ()
@property (assign,nonatomic) BOOL rainbowFading;
@property (assign,nonatomic) BOOL audioSyncing;

@end

@implementation EffectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)action:(id)sender {
    if(sender == _fastStrobeButton || sender == _slowStrobeButton) {
        if([OMDTorch shared].continueTorch && sender == _fastStrobeButton && [OMDTorch shared].frequency.floatValue == FAST_TORCH_FREQ) {
            [OMDTorch shared].continueTorch = NO;
        } else if([OMDTorch shared].continueTorch && sender == _slowStrobeButton && [OMDTorch shared].frequency.floatValue == SLOW_TORCH_FREQ) {
            [OMDTorch shared].continueTorch = NO;
        } else {
            [[OMDTorch shared] startTorching:OMDTorchModeFlash];
            [OMDTorch shared].frequency = (sender == _fastStrobeButton) ?  [NSNumber numberWithFloat:FAST_TORCH_FREQ] : [NSNumber numberWithFloat:SLOW_TORCH_FREQ];
        }
    } else if (sender == _rainbowFadeButton) {
        
    }
}
@end
