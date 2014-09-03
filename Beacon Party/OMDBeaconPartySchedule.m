//
//  OMDBeaconPartySchedule.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/29/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "OMDBeaconPartySchedule.h"
#import "OMDScreenColorSpec.h"
#import "Debug.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LARSTorch.h"

#define JITTER 0.5

@interface OMDBeaconPartySchedule()

- (void) runAction:(NSDictionary*)action;

@end


@implementation OMDBeaconPartySchedule

+ (id)scheduler {
    static OMDBeaconPartySchedule *scheduler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        scheduler = [[self alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [scheduler startLoop];
        });
    });
    return scheduler;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _continueMainLoop = YES;
    }
    return self;
}

- (void) startLoop {
    NSTimeInterval currentOffsetFromEpoch;
    while (_continueMainLoop) {
        if(_epoch && _schedules) {
            currentOffsetFromEpoch = [[NSDate date] timeIntervalSinceDate:_epoch];
            NSNumber *num = [NSNumber numberWithFloat:currentOffsetFromEpoch];
            NSArray *filteredarray = [_schedules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"((%K == nil OR %K == 0) AND %K <= %@)",@"executed",@"executed",@"time",num]];
            for (NSMutableDictionary *action in filteredarray) {
                if([[NSNumber numberWithBool:NO] compare:action[@"executed"]] == NSOrderedSame) {
                    [action setValue:@1 forKey:@"executed"];
                    DLog(@"Dispatching action %@", [action debugDescription]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self runAction:action];
                    });
                }
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K > %@)",@"time",num];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
            NSArray *results = [[_schedules filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            
            if([results count]>0) {
                float nextTime = ((NSNumber*)results[0][@"time"]).floatValue;
                currentOffsetFromEpoch = [[NSDate date] timeIntervalSinceDate:_epoch];
                [NSThread sleepForTimeInterval:nextTime-currentOffsetFromEpoch];
            }
            
            filteredarray = [_schedules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K == 0)",@"executed",num]];
            if([filteredarray count] == 0 )
                _continueMainLoop = NO;

        }
        
    }
}

- (void) runAction:(NSDictionary*)action {
    //remove any webview from the view
    [[self.view viewWithTag:1] removeFromSuperview];
    if([action[@"action"] isEqualToString:@"color"]) {
        OMDScreenColorSpec *colorSpec = [[OMDScreenColorSpec alloc] initWithR1:action[@"r1"] g1:action[@"g2"] b1:action[@"b1"] a1:action[@"a1"] r2:action[@"r2"] g2:action[@"g2"] b2:action[@"b2"] a2:action[@"a2"]];
        colorSpec.view = _view;
        colorSpec.debugTextView = _debugTextView;
        [colorSpec block]();
    } else if([action[@"action"] isEqualToString:@"stop"]) {
        _view.backgroundColor = [UIColor clearColor];
        [_view.layer removeAllAnimations];
    } else if([action[@"action"] isEqualToString:@"stop-flash"]) {
        _continueTorch = NO;
    } else if([action[@"action"] isEqualToString:@"url"]) {
        UIWebView *aWebView =[[UIWebView alloc] initWithFrame:_view.frame];
        aWebView.tag = 1;
        [aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:action[@"url"]]]];
        aWebView.delegate=self;
        //[self.view addSubview:aWebView];
        [self.view insertSubview:aWebView belowSubview:_debugTextView];
    } else if([action[@"action"] isEqualToString:@"sound"]) {
        NSString *localSoundName = action[@"local-file"];
        if(localSoundName) {
            SystemSoundID soundID;
            NSString *soundPath = [[NSBundle mainBundle]
                                    pathForResource:localSoundName ofType:nil];
            if(soundPath) {
                NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundUrl), &soundID);
                AudioServicesPlaySystemSound(soundID);
            }
        } else if([action objectForKey:@"url"]) {
            NSError *error;
            AVAudioPlayer *backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                          initWithContentsOfURL:[action objectForKey:@"url"] error:&error];
            [backgroundMusicPlayer prepareToPlay];
            [backgroundMusicPlayer play];
            if(error) {
                DLog(@"%@",[error debugDescription]);
            }
        }
    } else if([action[@"action"] isEqualToString:@"vibrate"]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else if([action[@"action"] isEqualToString:@"flash"]) {
        _continueTorch = YES;
        float period = ((NSNumber*)action[@"frequency"]).floatValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            LARSTorch *torch = [LARSTorch sharedTorch];
            
            while(_continueTorch) {
                if(action[@"brightness"]) {
                    [torch setTorchOnWithLevel:((NSNumber*)action[@"brightness"]).floatValue];
                } else {
                    [torch setTorchState:LARSTorchStateOn];
                }
                [NSThread sleepForTimeInterval:period/2.0];
                [torch setTorchState:LARSTorchStateOff];
                [NSThread sleepForTimeInterval:period/2.0];
            }
            
        });
        
    }
    
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
    
}


@end
