//
//  VisualizerView.cpp
//  Beacon Party
//
//  Created by Neel Banerjee on 9/16/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#include "VisualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "MeterTable.h"

// Change the private variable section of the implementation to look like this
@implementation VisualizerView {
    CAEmitterLayer *emitterLayer;
    MeterTable meterTable;
}

// 1
+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame color:_color];
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor*) color
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        // 2
        CGFloat width = frame.size.width;//MAX(frame.size.width, frame.size.height);
        CGFloat height = frame.size.height;//MIN(frame.size.width, frame.size.height);
        emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
        emitterLayer.emitterSize = CGSizeMake(width-80, 60);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        // 3
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name = @"cell";
        //cell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        // And replace it with the following lines
        CAEmitterCell *childCell = [CAEmitterCell emitterCell];
        childCell.name = @"childCell";
        childCell.lifetime = 1.0f / 60.0f;
        childCell.birthRate = 60.0f;
        childCell.velocity = 0.0f;
        
        childCell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        
        cell.emitterCells = @[childCell];
        // 4
        if(color) {
            _color = color;
            cell.color = [_color CGColor];
        } else {
            cell.color = [[UIColor colorWithRed:1.0f green:0.53f blue:0.0f alpha:0.8f] CGColor];
        }
        cell.redRange = 0.46f;
        cell.greenRange = 0.49f;
        cell.blueRange = 0.67f;
        cell.alphaRange = 0.55f;
        
        // 5
        cell.redSpeed = 0.11f;
        cell.greenSpeed = 0.07f;
        cell.blueSpeed = -0.25f;
        cell.alphaSpeed = 0.15f;
        
        // 6
        cell.scale = 0.5f;
        cell.scaleRange = 0.5f;
        
        // 7
        cell.lifetime = 1.0f;
        cell.lifetimeRange = .25f;
        cell.birthRate = 80;
        
        // 8
        cell.velocity = 100.0f;
        cell.velocityRange = 300.0f;
        cell.emissionRange = M_PI * 2;
        
        // 9
        emitterLayer.emitterCells = @[cell];
        CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}
- (void)update
{
    // 1
    float scale = 0.5;
    if (_audioPlayer.recording)
    {
        // 2
        [_audioPlayer updateMeters];
        
        // 3
        float power = 0.0f;
        for (int i = 0; i < 2; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
        }
        power /= 2;
        
        // 4
        float level = meterTable.ValueAt(power);
        scale = level * 5;
    }
    
    // 5
    //[emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.scale"];
    [emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}
@end