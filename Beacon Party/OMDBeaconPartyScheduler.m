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
#import "VisualizerView.h"


@interface OMDBeaconPartyScheduler()

- (void) runAction:(NSDictionary*)action;

- (void) startLoop;

- (void)stopSounds:(NSTimer*)timer;

- (void)removeRecordingFile;
- (void)showView;
- (void)hideView;

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
        backgroundAudioQueue = dispatch_queue_create("is.ziggy.audiobackground", DISPATCH_QUEUE_SERIAL);
        backgroundQueue = dispatch_queue_create("is.ziggy.background", NULL);
        _initialBrightness = [UIScreen mainScreen].brightness;
        _actioning = 0;
        _userStop = NO;
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
                            if(!_userStop) {
                                DLog(@"Dispatching action %@", [action debugDescription]);
                                [self runAction:action];
                            }
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
- (void) hideView {
    self.actioning -= 1;
    dispatch_async(dispatch_get_main_queue(),^{
        [UIView transitionWithView:_view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.view.hidden = YES;
        [UIScreen mainScreen].brightness =_initialBrightness;
    });
}

- (void) showView {
    self.actioning += 1;

    if (!_userStop) {
            dispatch_async(dispatch_get_main_queue(),^{
                _initialBrightness = [UIScreen mainScreen].brightness;
            [UIView transitionWithView:_view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            self.view.hidden = NO;
            [UIScreen mainScreen].brightness = 1.0;
        
        });
    }
    
}
#define ARC4RANDOM_MAX      0x100000000
- (void) runAction:(NSDictionary*)action {
    if ([action[@"action"] isEqualToString:@"color"] || [action[@"action"] isEqualToString:@"rainbow"]) {
        [self showView];
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
        
        if (action[@"brightness"]){
            colorSpec.brightness = ((NSNumber*)action[@"brightness"]).doubleValue;
        } else {
            colorSpec.brightness = 1;
        }
        
        colorSpec.view = _view;
        colorSpec.debugTextView = _debugTextView;
        if([action[@"action"] isEqualToString:@"color"])
            dispatch_async(dispatch_get_main_queue(), [colorSpec block]);
        else
            dispatch_async(dispatch_get_main_queue(), [colorSpec rainbowBlock]);
    } else if([action[@"action"] isEqualToString:@"stop"]) {
        [self hideView];
        dispatch_async(dispatch_get_main_queue(), ^{
            _view.backgroundColor = [UIColor blackColor];
            [_view.layer removeAllAnimations];
        });
    } else if([action[@"action"] isEqualToString:@"stop-flash"]) {
        self.actioning -= 1;
        _torch.continueTorch = NO;
    } else if([action[@"action"] isEqualToString:@"url"]) {
        [self showView];
        dispatch_async(dispatch_get_main_queue(), ^{
            _view.backgroundColor = [UIColor blackColor];
            [_view.layer removeAllAnimations];
            if(!_aWebView) {
                _aWebView =[[UIWebView alloc] initWithFrame:_view.frame];
                _aWebView.delegate=self;
                _aWebView.tag = 1;
                [self.view insertSubview:_aWebView atIndex:0];
            }
            [_aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:action[@"url"]]]];
            
            //[self.view insertSubview:aWebView belowSubview:_debugTextView];
        });
    } else if([action[@"action"] isEqualToString:@"stop-url"]) {
        [self hideView];
        //remove any webview from the view
        dispatch_async(dispatch_get_main_queue(), ^{[[self.view viewWithTag:1] removeFromSuperview];});
    }
    else if([action[@"action"] isEqualToString:@"sound"]) {
        //Setting actioning only is looping - see below
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
                    self.actioning += 1;
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
        self.actioning -= 1;
        dispatch_async(backgroundAudioQueue, ^{ if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];});
    } else if([action[@"action"] isEqualToString:@"vibrate"]) {
        //Not setting actioning since this is short
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    } else if([action[@"action"] isEqualToString:@"flash"]) {
        self.actioning += 1;
        //Torching is done on a seperate thread
        if(action[@"frequency"]) {
            _torch.frequency = action[@"frequency"];
        } else {
            _torch.frequency = [NSNumber numberWithFloat:1.0];
        }
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
        _torch.mode = OMDTorchModeFlash;
        [_torch startTorching];
          
    } else if([action[@"action"] isEqualToString:@"twinkle"]) {
        self.actioning += 1;
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
        _torch.mode = OMDTorchModeTwinkle;
        [_torch startTorching];
        
        
    } else if([action[@"action"] isEqualToString:@"stop-all"]) {
        [self hideView];
        [self clearEffects];
    } else if([action[@"action"] isEqualToString:@"particle"]) {
        [self showView];
        dispatch_async(dispatch_get_main_queue(),^{
            //Remove the view if it already exists
            [[self.view viewWithTag:2] removeFromSuperview];
            
            VisualizerView *visualizer;
            if(action[@"r1"] && action[@"g1"]&& action[@"b1"]&& action[@"a1"]) {
                UIColor *color = [UIColor colorWithRed:((NSNumber*)action[@"r1"]).floatValue green:((NSNumber*)action[@"g1"]).floatValue blue:((NSNumber*)action[@"b1"]).floatValue alpha:((NSNumber*)action[@"a1"]).floatValue];
                visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame color:color];
            } else {
                visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame color:nil];
            }
            [visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            visualizer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [visualizer setBackgroundColor:[UIColor blackColor]];
            visualizer.tag = 2;
            [self.view insertSubview:visualizer atIndex:0];
            NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                              [NSNumber numberWithInt:44100],AVSampleRateKey,
                                              [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                              nil];
            NSError* error = nil;
            
            // New recording path.
            NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], @"cache"];
            NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
            
            visualizer.audioPlayer = [[AVAudioRecorder alloc] initWithURL:url  settings:recorderSettings error:&error];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
            visualizer.audioPlayer.meteringEnabled = YES;
            
            if([visualizer.audioPlayer prepareToRecord])
            {
                [visualizer.audioPlayer record];
                [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(removeRecordingFile) userInfo:nil repeats:NO];
            }
        });

    } else if([action[@"action"] isEqualToString:@"stop-particle"]) {
        [self hideView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self.view viewWithTag:2] removeFromSuperview];
        });
    }
    
}

- (void)removeRecordingFile
{
    dispatch_async(dispatch_get_main_queue(),^{
        // Remove the data file from the recording.
        NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], @"cache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:recorderFilePath]) {
            BOOL success = [fileManager removeItemAtPath:recorderFilePath error:&error];
            if(success)
            {
                NSLog(@"Deleted recording file");
            }
            else
            {
                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            }
        }
    });
}


- (void)stopSounds:(NSTimer*)timer {
    dispatch_async(backgroundAudioQueue, ^{
        if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];
    });
}

- (void)clearEffects {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.view viewWithTag:1] removeFromSuperview]; //Remove the webview
        [[self.view viewWithTag:2] removeFromSuperview]; //Remove the particle view
        _view.backgroundColor = [UIColor blackColor];
        [_view.layer removeAllAnimations];
        _torch.continueTorch = NO;
    });
    dispatch_async(backgroundAudioQueue, ^{
        if(_backgroundMusicPlayer)[_backgroundMusicPlayer stop];
    });
}

- (void) setUserStop:(BOOL) stop {
    _userStop = stop;
    if(_userStop == YES) {
        _continueMainLoop = NO;
        [self clearEffects];
        self.actioning = 0;
    }
    //We handle starting the main loop when we reload the file
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
