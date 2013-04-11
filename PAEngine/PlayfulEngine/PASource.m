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
#import "PAEffectCombFilter.h"

#import "PAClipPlayer.h"
#import "PASineGenerator.h"

@implementation PASource {
    PAParameterAverager *panAverager;
    PAParameterAverager *volumeAverager;
    PAEffectCombFilter *combFilter0;
    PAEffectCombFilter *combFilter1;
    PAEffectCombFilter *combFilter2;
    PAEffectCombFilter *combFilter3;
}

- (id)init {
    self = [super init];
    if (self) {
        _sourceObject = nil;
        panAverager = [[PAParameterAverager alloc] init];
        volumeAverager = [[PAParameterAverager alloc] init];
        [self setVolume:0.5f];
        [self setPan:0.5f];
        
        combFilter0 = [[PAEffectCombFilter alloc] init];
        combFilter1 = [[PAEffectCombFilter alloc] init];
        combFilter2 = [[PAEffectCombFilter alloc] init];
        combFilter3 = [[PAEffectCombFilter alloc] init];
        
        [combFilter0 setDelayTimeMs:300.0f];
        [combFilter1 setDelayTimeMs:30.0f];
        [combFilter2 setDelayTimeMs:2000.0f];
        [combFilter3 setDelayTimeMs:10.0f];
        
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
    
    // Sum 4 comb filters together and divide by 4
    Float32 comb0OutputL[inNumberFrames];
    Float32 comb0OutputR[inNumberFrames];
    Float32 comb1OutputL[inNumberFrames];
    Float32 comb1OutputR[inNumberFrames];
    Float32 comb2OutputL[inNumberFrames];
    Float32 comb2OutputR[inNumberFrames];
    Float32 comb3OutputL[inNumberFrames];
    Float32 comb3OutputR[inNumberFrames];
    
    Float32 sumBufferL[inNumberFrames];
    Float32 sumBufferR[inNumberFrames];

    [combFilter0 processLeftInput:leftBuffer andRightInput:rightBuffer toLeftOutput:comb0OutputL andRightOutput:comb0OutputR inNumberSamples:inNumberFrames];
    [combFilter1 processLeftInput:leftBuffer andRightInput:rightBuffer toLeftOutput:comb1OutputL andRightOutput:comb1OutputR inNumberSamples:inNumberFrames];
    [combFilter2 processLeftInput:leftBuffer andRightInput:rightBuffer toLeftOutput:comb2OutputL andRightOutput:comb2OutputR inNumberSamples:inNumberFrames];
    [combFilter3 processLeftInput:leftBuffer andRightInput:rightBuffer toLeftOutput:comb3OutputL andRightOutput:comb3OutputR inNumberSamples:inNumberFrames];

    
    
    vDSP_vadd(comb0OutputL, 1, comb1OutputL, 1, sumBufferL, 1, inNumberFrames);
    vDSP_vadd(comb0OutputR, 1, comb1OutputR, 1, sumBufferR, 1, inNumberFrames);
    vDSP_vadd(comb2OutputL, 1, sumBufferL, 1, sumBufferL, 1, inNumberFrames);
    vDSP_vadd(comb2OutputR, 1, sumBufferR, 1, sumBufferR, 1, inNumberFrames);
    vDSP_vadd(comb3OutputL, 1, sumBufferL, 1, sumBufferL, 1, inNumberFrames);
    vDSP_vadd(comb3OutputR, 1, sumBufferR, 1, sumBufferR, 1, inNumberFrames);
    
    float combGain = 0.25f;
    vDSP_vsmul(sumBufferL, 1, &combGain, sumBufferL, 1, inNumberFrames);
    vDSP_vsmul(sumBufferR, 1, &combGain, sumBufferR, 1, inNumberFrames);
    
    printf("left samp: %f\t comb samp: %f\n", *leftBuffer, *sumBufferL);
    
    // Add comb filters back to output buffer
    vDSP_vadd(leftBuffer, 1, sumBufferL, 1, leftBuffer, 1, inNumberFrames);
    vDSP_vadd(rightBuffer, 1, sumBufferR, 1, rightBuffer, 1, inNumberFrames);
    
    // All pass filter 1
    // All pass filter 2
    
    // Volume param
    vDSP_vsmul(leftBuffer, 1, &leftGain, leftBuffer, 1, inNumberFrames);
    vDSP_vsmul(rightBuffer, 1, &rightGain, rightBuffer, 1, inNumberFrames);
}

@end