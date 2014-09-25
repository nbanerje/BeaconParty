//
//  EffectsViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "EffectsViewController.h"
#import "OMDScreenColorSpec.h"
#import "OMDTorch.h"
#define FAST_TORCH_FREQ 40.0
#define SLOW_TORCH_FREQ 4.0

#define FAST_MODE 1
#define SLOW_MODE 2
#define RAINBOW_MODE 3

@interface EffectsViewController ()
@property (assign,nonatomic) BOOL rainbowFading;
@property (assign,nonatomic) BOOL audioSyncing;
@property (assign,nonatomic) CGFloat brightness;
@property (assign,nonatomic) NSInteger mode;
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
    _rainbowView.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    [OMDTorch shared].continueTorch = NO;
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
    if (sender == _fastStrobeButton || sender == _slowStrobeButton || sender == _rainbowFadeButton) {
        OMDScreenColorSpec *colorSpec = [[OMDScreenColorSpec alloc] init];
        colorSpec.view = _rainbowView;
        
        if ((sender == _fastStrobeButton && _mode == FAST_MODE) ||
            (sender == _slowStrobeButton && _mode == SLOW_MODE) ||
            (sender == _rainbowFadeButton && _mode == RAINBOW_MODE)
            ) {
            _rainbowView.hidden = YES;
            [_rainbowView.layer removeAllAnimations];
            [UIScreen mainScreen].brightness = _brightness;
        } else {
            _brightness = [UIScreen mainScreen].brightness;
            _rainbowView.hidden = NO;

            if (sender == _fastStrobeButton) {
                _mode = FAST_MODE;
                colorSpec.frequency = 5;
                colorSpec.color1 = [UIColor blackColor];
                colorSpec.color2 = [UIColor whiteColor];
                [colorSpec block]();
                
            } else if (sender == _slowStrobeButton) {
                _mode = SLOW_MODE;
                colorSpec.frequency = 1;
                colorSpec.color1 = [UIColor blackColor];
                colorSpec.color2 = [UIColor whiteColor];
                [colorSpec block]();
            } else if (sender == _rainbowFadeButton) {
                _mode = RAINBOW_MODE;
                colorSpec.frequency = 1;
                [colorSpec rainbowBlock]();
                
            }

        }
        
        if(sender == _fastStrobeButton || sender == _slowStrobeButton) {
            if([OMDTorch shared].continueTorch && sender == _fastStrobeButton && [OMDTorch shared].frequency.floatValue == FAST_TORCH_FREQ) {
                [OMDTorch shared].continueTorch = NO;
            } else if([OMDTorch shared].continueTorch && sender == _slowStrobeButton && [OMDTorch shared].frequency.floatValue == SLOW_TORCH_FREQ) {
                [OMDTorch shared].continueTorch = NO;
            } else {
                [OMDTorch shared].mode = OMDTorchModeFlash;
                [OMDTorch shared].frequency = (sender == _fastStrobeButton) ?  [NSNumber numberWithFloat:FAST_TORCH_FREQ] : [NSNumber numberWithFloat:SLOW_TORCH_FREQ];
                [[OMDTorch shared] startTorching];
            }
        } else {
            [OMDTorch shared].continueTorch = NO;
        }
        
    }
}
@end
