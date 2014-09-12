//
//  OMDBeaconPartySchedule.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/29/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "OMDBeaconPartyScheduler.h"
#import "OMDScreenColorSpec.h"
#import "Debug.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "OMDTorch.h"


@interface OMDBeaconPartyScheduler()

- (void) runAction:(NSDictionary*)action;

/**
 Start the loop scheduler. This is started automatically by instantiating
 the scheduler singleton.
 */
- (void) startLoop;

- (void)stopSounds:(NSTimer*)timer;

/**
 This value can be used to stop the scheduler. If you stop the scheduler you
 will need to restart the scheduler with the startLoop method after setting
 continueMainLoop = YES;
 */
@property (assign, nonatomic) BOOL continueMainLoop;

@property (assign, atomic) UInt16 numLoops;

@property (strong, nonatomic) OMDTorch *torch;

@property (strong, nonatomic) UIWebView *aWebView;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) NSTimer *timer;

@end


@implementation OMDBeaconPartyScheduler

+ (id)scheduler {
    static OMDBeaconPartyScheduler *scheduler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        scheduler = [[self alloc] init];
    });
    return scheduler;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _continueMainLoop = YES;
        _numLoops = 0;
        _torch = [OMDTorch shared];
        backgroundAudioQueue = dispatch_queue_create("is.ziggy.audiobackground", NULL);
        backgroundQueue = dispatch_queue_create("is.ziggy.background", NULL);
        
    }
    return self;
}

-(void) setSequences:(NSArray *)sequences {
    _sequences = sequences;
    _continueMainLoop = YES;
    [self startLoop];
}

-(void) setBeacon:(CLBeacon *)beacon {
    _beacon = beacon;
    _torch.beacon = beacon;
}

- (void) startLoop {
    
    if (_numLoops==0) {
        ++_numLoops;
        dispatch_async(backgroundQueue, ^{
            while (_continueMainLoop) {
                @autoreleasepool {
                    NSTimeInterval currentOffsetFromEpoch = [[NSDate date] timeIntervalSinceDate:_epoch];
                    NSNumber *num = [NSNumber numberWithDouble:currentOffsetFromEpoch];
                    NSArray *filteredarray = [_sequences filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"((%K == nil OR %K == 0) AND %K <= %@)",@"executed",@"executed",@"time",num]];
                    for (NSMutableDictionary *action in filteredarray) {
                        if([[NSNumber numberWithBool:NO] compare:action[@"executed"]] == NSOrderedSame) {
                            [action setValue:@1 forKey:@"executed"];
                            DLog(@"Dispatching action %@", [action debugDescription]);
                            [self runAction:action];
                        }
                    }
                    
                    //If there are sequences in the future sleep the thread until those are ready to execute.
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K > %@)",@"time",num];
                    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
                    NSArray *results = [[_sequences filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
                    
                    if([results count]>0) {
                        double nextTime = ((NSNumber*)results[0][@"time"]).doubleValue;
                        currentOffsetFromEpoch = [[NSDate date] timeIntervalSinceDate:_epoch];
                        [NSThread sleepForTimeInterval:nextTime-currentOffsetFromEpoch];
                    }
                    
                    //End the loop when all sequence are in the past or have been executed
                    if(_sequences) {
                        filteredarray = [_sequences filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K == 0 || %K >= %@)",@"executed",@"time",num]];
                        if(filteredarray && [filteredarray count] == 0 )
                            _continueMainLoop = NO;
                    }
                }
                
            }
            _numLoops--;
        });

    }
}
#define ARC4RANDOM_MAX      0x100000000
- (void) runAction:(NSDictionary*)action {
    //remove any webview from the view
    dispatch_async(dispatch_get_main_queue(), ^{[[self.view viewWithTag:1] removeFromSuperview];});
    
    if ([action[@"action"] isEqualToString:@"color"] || [action[@"action"] isEqualToString:@"rainbow"]) {
        OMDScreenColorSpec *colorSpec;
        if([action[@"action"] isEqualToString:@"color"])
            colorSpec = [[OMDScreenColorSpec alloc] initWithR1:action[@"r1"] g1:action[@"g1"] b1:action[@"b1"] a1:action[@"a1"] r2:action[@"r2"] g2:action[@"g2"] b2:action[@"b2"] a2:action[@"a2"]];
        else {
            colorSpec =[[OMDScreenColorSpec alloc] init];
        }
        
        if (action[@"frequency"]){
            colorSpec.frequency = ((NSNumber*)action[@"frequency"]).floatValue;
        } else {
            colorSpec.frequency = 1;
        }
        
        if (action[@"delay"] && action[@"rand"] == nil ){
            colorSpec.delay = ((NSNumber*)action[@"delay"]).floatValue;
        } else if (action[@"delay"] && ((NSNumber*)action[@"rand"]).boolValue == YES) {
             colorSpec.delay = floorf(((float)arc4random() / ARC4RANDOM_MAX) * ((NSNumber*)action[@"delay"]).floatValue);
        } else {
            colorSpec.delay = 0;
        }
        
        colorSpec.view = _view;
        colorSpec.debugTextView = _debugTextView;
        if([action[@"action"] isEqualToString:@"color"])
            dispatch_async(dispatch_get_main_queue(), ^{[colorSpec block]();});
        else
            dispatch_async(dispatch_get_main_queue(), ^{[colorSpec rainbowBlock]();});
    } else if([action[@"action"] isEqualToString:@"stop"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _view.backgroundColor = [UIColor whiteColor];
            [_view.layer removeAllAnimations];
        });
    } else if([action[@"action"] isEqualToString:@"stop-flash"]) {
        _torch.continueTorch = NO;
    } else if([action[@"action"] isEqualToString:@"url"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _view.backgroundColor = [UIColor whiteColor];
            [_view.layer removeAllAnimations];
            if(!_aWebView) {
                _aWebView =[[UIWebView alloc] initWithFrame:_view.frame];
                _aWebView.delegate=self;
                [self.view insertSubview:_aWebView atIndex:0];
            }
            [_aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:action[@"url"]]]];
            
            //[self.view insertSubview:aWebView belowSubview:_debugTextView];
        });
    } else if([action[@"action"] isEqualToString:@"sound"]) {
        NSString *localSoundName = action[@"local-file"];
        NSURL *soundUrl;
        if(localSoundName) {
            NSString *soundPath = [[NSBundle mainBundle]
                                    pathForResource:localSoundName ofType:nil];
            if(soundPath) {
                soundUrl = [NSURL fileURLWithPath:soundPath];
            }
        } else if(action[@"url"]) {
            soundUrl = [NSURL URLWithString:action[@"url"]];
        }
        dispatch_async(backgroundAudioQueue, ^{
            NSError *error;
            _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                                    initWithData:[NSData dataWithContentsOfURL:soundUrl] error:&error];
            if(action[@"loop"]) {
                BOOL loop = ((NSNumber*)action[@"loop"]).boolValue;
                if (loop) {
                    _backgroundMusicPlayer.numberOfLoops = -1;
                }
            }
            [_backgroundMusicPlayer prepareToPlay];
            [_backgroundMusicPlayer play];
            if(error) {
                DLog(@"%@",[error debugDescription]);
            }
            if(action[@"duration"]) {
                NSTimeInterval duration = ((NSNumber*)action[@"duration"]).floatValue;
                dispatch_async(dispatch_get_main_queue(),^{
                   [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(stopSounds:) userInfo:nil repeats:NO]; 
                });
            }
            
        });
    } else if([action[@"action"] isEqualToString:@"stop-sound"]) {
        dispatch_async(backgroundAudioQueue, ^{ if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];});
    } else if([action[@"action"] isEqualToString:@"vibrate"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    } else if([action[@"action"] isEqualToString:@"flash"]) {
        //Torching is done on a seperate thread
        _torch.frequency = action[@"frequency"];
        if(action[@"brightness"]) {
            _torch.brightness = action[@"brightness"];
        } else {
            _torch.brightness = [NSNumber numberWithFloat:1.0];
        }
        
        if (action[@"delay"] && action[@"rand"] == nil ){
            _torch.delay = (NSNumber*)action[@"delay"];
        } else if (action[@"delay"] && ((NSNumber*)action[@"rand"]).boolValue == YES) {
            _torch.delay = [NSNumber numberWithDouble:floor(((double)arc4random() / ARC4RANDOM_MAX) * ((NSNumber*)action[@"delay"]).doubleValue)];
        } else {
            _torch.delay = [NSNumber numberWithDouble:0.0];
        }
        [_torch startTorching:OMDTorchModeFlash];
    } else if([action[@"action"] isEqualToString:@"twinkle"]) {
        //Torching is done on a seperate thread
        if (action[@"max-frequency"]) {
            _torch.maxFrequency = action[@"max-frequency"];
        }
        if(action[@"offset"]) {
            _torch.offset = action[@"offset"];
        } else {
            _torch.offset = [NSNumber numberWithDouble:0.0];
        }
        if (action[@"inverse"]) {
            _torch.inverse = ((NSNumber*)action[@"inverse"]).boolValue;
        } else {
            _torch.inverse = NO;
        }
        if(action[@"brightness"]) {
            _torch.brightness = action[@"brightness"];
        } else {
            _torch.brightness = [NSNumber numberWithDouble:1.0];
        }
        if (action[@"delay"] && action[@"rand"] == nil ){
            _torch.delay = (NSNumber*)action[@"delay"];
        } else if (action[@"delay"] && ((NSNumber*)action[@"rand"]).boolValue == YES) {
            _torch.delay = [NSNumber numberWithDouble:floor(((double)arc4random() / ARC4RANDOM_MAX) * ((NSNumber*)action[@"delay"]).doubleValue)];
        } else {
            _torch.delay = [NSNumber numberWithDouble:0];
        }
        [_torch startTorching:OMDTorchModeTwinkle];
        
        
    }
    
}

- (void)stopSounds:(NSTimer*)timer {
    dispatch_async(backgroundAudioQueue, ^{ if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];});
}

- (void)clearEffects {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.view viewWithTag:1] removeFromSuperview]; //Remove the webview
        _view.backgroundColor = [UIColor whiteColor];
        [_view.layer removeAllAnimations];
    });
    dispatch_async(backgroundAudioQueue, ^{ if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];});
}

#pragma mark UIWebView delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"%@",[error debugDescription]);
}


@end
