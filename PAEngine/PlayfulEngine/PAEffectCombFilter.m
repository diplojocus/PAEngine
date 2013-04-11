//
//  PAEffectCombFilter.m
//  PAEngine
//
//  Created by Joe White on 10/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#include <math.h>

#import "PAEffectCombFilter.h"

@implementation PAEffectCombFilter {
    float *delayBufferL;
    float *delayBufferR;
    float sampleRate;
    float rt60;
    float g;
    float reverbTime;
    unsigned int pos;
    unsigned int delaySizeInSamples;
}

- (id)init {
    self = [super init];
    if (self) {
        delayBufferL = nil;
        delayBufferR = nil;
        sampleRate = 44100.0f;
        rt60 = 100.0f;
        g = 0.0f;
        reverbTime = 0.0f;
        pos = 0;
        delaySizeInSamples = 0;
    }
    return self;
}

- (void)setDelayTimeMs:(float)delayTime {
    _delayTimeMs = delayTime;
    g = powf(0.001, rt60 * _delayTimeMs);
    [self setBufferSize:(unsigned int)floorf(sampleRate / _delayTimeMs)];
}

- (void)setBufferSize:(unsigned int)bufferSize {
    delaySizeInSamples = bufferSize;
    
    free(delayBufferL);
    free(delayBufferR);
    
    delayBufferL = calloc(bufferSize, sizeof(float));
    delayBufferR = calloc(bufferSize, sizeof(float));
}

- (void)incrementReadPos {
    pos++;
    if (pos > delaySizeInSamples) {
        pos -= delaySizeInSamples;
    }
}

- (void)processLeftInput:(const float *)inputL
           andRightInput:(const float *)inputR
            toLeftOutput:(float *)outputL
          andRightOutput:(float *)outputR
         inNumberSamples:(unsigned int)numSamples {
    
    float tempOutL;
    float tempOutR;
    
    for (int i = 0; i < numSamples; i++) {
        
        tempOutL = delayBufferL[pos];
        tempOutR = delayBufferR[pos];
        
        delayBufferL[pos] = inputL[i] + tempOutL * g;
        delayBufferR[pos] = inputR[i] + tempOutR * g;
        
        outputL[i] = tempOutL;
        outputR[i] = tempOutR;
        
        [self incrementReadPos];
    }
}

- (void)dealloc {
    free(delayBufferL);
    free(delayBufferR);
}

@end