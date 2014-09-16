//
//  VizViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/16/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "VizViewController.h"
#import "VisualizerView.h"
@interface VizViewController ()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) VisualizerView *visualizer;
- (void)removeRecordingFile;
@end

@implementation VizViewController

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
    [self configureBars];
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    NSError* error = nil;
    if (!self.visualizer.audioPlayer) {
        // New recording path.
        NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], @"cache"];
        NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
        
        //self.visualizer.audioPlayer = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"/dev/null"]  settings:recorderSettings error:&error];
        self.visualizer.audioPlayer = [[AVAudioRecorder alloc] initWithURL:url  settings:recorderSettings error:&error];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        self.visualizer.audioPlayer.meteringEnabled = YES;
        
        if([self.visualizer.audioPlayer prepareToRecord])
        {
            [self.visualizer.audioPlayer record];
            [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(removeRecordingFile) userInfo:nil repeats:NO];
        }
    }
    
}
- (void)removeRecordingFile
{
    // Remove the data file from the recording.
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], @"cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
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

- (void)configureBars {
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect frame = self.view.frame;
    
    self.backgroundView = [[UIView alloc] initWithFrame:frame];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //[_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_backgroundView];
    
}


@end
