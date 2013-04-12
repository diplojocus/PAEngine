//
//  PAEffectAllPassFilter.m
//  PAEngine
//
//  Created by Joe White on 12/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PAEffectAllPassFilter.h"

@implementation PAEffectAllPassFilter {
    float *delayBufferL;
    float *delayBufferR;
    float sampleRate;
    float g;
    unsigned int pos;
    unsigned int delaySizeInSamples;
}

- (id)init {
    self = [super init];
    if (self) {
        delayBufferL = nil;
        delayBufferR = nil;
        sampleRate = 44100.0f;
        _rt60 = 1000.0f;
        g = 0.0f;
        pos = 0;
        delaySizeInSamples = 0;
    }
    return self;
}

- (void)setDelayTimeMs:(float)delayTime {
    _delayTimeMs = delayTime;
    g = powf(0.001, _delayTimeMs / _rt60);
    [self setBufferSize:(unsigned int)floorf(sampleRate * (_delayTimeMs / 1000.0f))];
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

- (void)processLeftInput:(float *)inputL
           andRightInput:(float *)inputR
         inNumberSamples:(unsigned int)numSamples {
    
    float tempOutL;
    float tempOutR;
    
    for (int i = 0; i < numSamples; i++) {
        
        tempOutL = delayBufferL[pos];
        tempOutR = delayBufferR[pos];
        delayBufferL[pos] = inputL[i] + tempOutL * g;
        delayBufferR[pos] = inputR[i] + tempOutR * g;
        inputL[i] = tempOutL - (g * inputL[i]);
        inputR[i] = tempOutR - (g * inputR[i]);
        [self incrementReadPos];
    }
}

- (void)dealloc {
    free(delayBufferL);
    free(delayBufferR);
}

@end
