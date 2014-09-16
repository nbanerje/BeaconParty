//
//  VisualizerView.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/16/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

//Add with the other imports
#import <AVFoundation/AVFoundation.h>

@interface VisualizerView : UIView
- (id)initWithFrame:(CGRect)frame color:(UIColor*) color;
//Add within the @interface and @end lines
@property (strong, nonatomic) AVAudioRecorder *audioPlayer;
@property (strong, nonatomic) UIColor *color;
@end

