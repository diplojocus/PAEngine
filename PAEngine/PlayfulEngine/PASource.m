//
//  PASource.m
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#include <Accelerate/Accelerate.h>

#import "PASource.h"

#import "PAParameterAverager.h"
#import "PAClipPlayer.h"
#import "PASineGenerator.h"

@implementation PASource {
    PAParameterAverager *panAverager;
    PAParameterAverager *volumeAverager;
}

- (id)init {
    self = [super init];
    if (self) {
        _sourceObject = nil;
        panAverager = [[PAParameterAverager alloc] init];
        volumeAverager = [[PAParameterAverager alloc] init];
        [self setVolume:0.5f];
        [self setPan:0.5f];
    }
    return self;
}

- (void)setAudioClipWithURL:(NSURL *)clipURL {
    _sourceObject = [self audioClipWithURL:clipURL];
}

- (PAClipPlayer *)audioClipWithURL:(NSURL *)clipURL {
    PAClipPlayer *newClipPlayer = [[PAClipPlayer alloc] init];
    [newClipPlayer openFileWithPath:[clipURL path]];
    return newClipPlayer;
}

- (void)setPan:(float)pan {
    _pan = MIN(1.0f, pan);
    _pan = MAX(0.0f, _pan);
}

- (void)setVolume:(float)volume {
    _volume = MIN(1.0f, volume);
    _volume = MAX(0.0f, _volume);
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
    
    float leftGain = cos(_pan * M_PI_2) * _volume;
    float rightGain = sin(_pan * M_PI_2) * _volume;
    
    [_sourceObject processBuffersLeft:leftBuffer right:rightBuffer numFrames:inNumberFrames];
    
    // Comb filter 1
    
    // Comb filter 2
    
    // Comb filter 3
    
    // Comb filter 4
    
    // Sum 4 comb filters together and divide by 4
    
    // All pass filter 1
    
    // All pass filter 2
    
    vDSP_vsmul(leftBuffer, 1, &leftGain, leftBuffer, 1, inNumberFrames);
    vDSP_vsmul(rightBuffer, 1, &rightGain, rightBuffer, 1, inNumberFrames);
}

@end