//
//  OpenGLWaveformViewController.m
//  EZAudioOpenGLWaveformExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2013 Syed Haris Ali. All rights reserved.
//

#import "OpenGLWaveformViewController.h"
#import "FFTAccelerate.h"
@interface OpenGLWaveformViewController ()
#pragma mark - UI Extras
@property (nonatomic,weak) IBOutlet UILabel *microphoneTextLabel;
@property (nonatomic) float *frequency;
@end

@implementation OpenGLWaveformViewController
@synthesize audioPlot;
@synthesize microphone;

#pragma mark - Initialization
-(id)init {
  self = [super init];
  if(self){
    [self initializeViewController];
      _frequency = (float *)malloc(sizeof(float)*1024);
  }
  return self;
}

-(void) dealloc {
    free(_frequency);
}
-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self){
    [self initializeViewController];
      _frequency = (float *)malloc(sizeof(float)*1024);
  }
  return self;
}

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
  // Create an instance of the microphone and tell it to use this view controller instance as the delegate
  self.microphone = [EZMicrophone microphoneWithDelegate:self];
}

#pragma mark - Customize the Audio Plot
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /*
   Customizing the audio plot's look
   */
  // Background color
  self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.569 green: 0.82 blue: 0.478 alpha: 1];
  // Waveform color
  self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  // Plot type
  self.audioPlot.plotType        = EZPlotTypeBuffer;
  
  /*
   Start the microphone
   */
  //[self.microphone startFetchingAudio];
  //self.microphoneTextLabel.text = @"Microphone On";
  
}

- (void)viewDidAppear:(BOOL)animated{
    [self.microphone startFetchingAudio];
    self.microphoneTextLabel.text = @"Microphone On";
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.microphone stopFetchingAudio];
}

#pragma mark - Actions
-(void)changePlotType:(id)sender {
  NSInteger selectedSegment = [sender selectedSegmentIndex];
  switch(selectedSegment){
    case 0:
      [self drawBufferPlot];
      break;
    case 1:
      [self drawRollingPlot];
      break;
    default:
      break;
  }
}

-(void)toggleMicrophone:(id)sender {
  if( ![(UISwitch*)sender isOn] ){
    [self.microphone stopFetchingAudio];
    self.microphoneTextLabel.text = @"Microphone Off";
  }
  else {
    [self.microphone startFetchingAudio];
    self.microphoneTextLabel.text = @"Microphone On";
  }
}

#pragma mark - Action Extensions
/*
 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input eample)
 */
-(void)drawBufferPlot {
  // Change the plot type to the buffer plot
  self.audioPlot.plotType = EZPlotTypeBuffer;
  // Don't mirror over the x-axis
  self.audioPlot.shouldMirror = NO;
  // Don't fill
  self.audioPlot.shouldFill = NO;
}

/*
 Give the classic mirrored, rolling waveform look
 */
-(void)drawRollingPlot {
  self.audioPlot.plotType = EZPlotTypeRolling;
  self.audioPlot.shouldFill = YES;
  self.audioPlot.shouldMirror = YES;
}

#pragma mark - EZMicrophoneDelegate
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    //Number of Samples for input(time domain)/output(frequency domain)
    //Must be Power of 2: 2^x
    int numSamples = 1024;
    
    //Output Array
    //float *frequency = (float *)malloc(sizeof(float)*numSamples);
    
    //Input Array
    //float *time = (float *)malloc(sizeof(float)*numSamples);
    
    //Fill Input Array with Sin Wave
    /*for (int i=0; i<numSamples; i++) {
        
        //DC Component frequency[0] = 0.5
        time[i] = 0.25;
        
        //First Harmonic (frequency[1]=1.0)
        time[i] += cos(2*M_PI*i/(float)numSamples);
        
        //Second Harmonic (frequency[2]=1.0)
        time[i] += cos(2*M_PI*2*i/numSamples);
        
        //Third Harmonic (frequency[3]=1.0)
        time[i] += cos(2*M_PI*3*i/numSamples);
    }*/
    
    
    
    /*FFTAccelerate *fftAccel = new FFTAccelerate(numSamples);
    fftAccel->doFFTReal(buffer[0], _frequency, numSamples);
    delete(fftAccel);*/
//    for (int i=0; i<numSamples; i++) {
//        NSLog(@"index: %d, amp: %.2f",i, frequency[i]);
//    }
    
  // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
  // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
  dispatch_async(dispatch_get_main_queue(),^{
    // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
    [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    //  [self.audioPlot updateBuffer:_frequency withBufferSize:bufferSize];
      
  });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
  // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
  // Here's a print function to allow you to inspect it a little easier
  [EZAudio printASBD:audioStreamBasicDescription];
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  // Getting audio data as a buffer list that can be directly fed into the EZRecorder or EZOutput. Say whattt...
}

@end
