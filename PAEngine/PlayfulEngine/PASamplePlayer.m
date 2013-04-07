//
//  PASamplePlayer.m
//  PAEngine
//
//  Created by Joe White on 03/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASamplePlayer.h"
#include "sndfile.h"

@implementation PASamplePlayer

- (id)init {
    self = [super init];
    if (self) {
        // Defaults
        _numberChannels = 0;
        _numberFrames = 0;
        [self setCurrentReadPosition:0];
        [self setPan:0.5];
        [self setVolume:0.5];
    }
    return self;
}

- (void)openFileWithPath:(NSString *)path {
    SF_INFO inputFormat = {0};
    SNDFILE *inputFile = sf_open([path cStringUsingEncoding:NSUTF8StringEncoding], SFM_READ, &inputFormat);
    
    _numberChannels = inputFormat.channels;
    _numberFrames = inputFormat.frames;
    
    Float32 fileBuffer[self.numberSamples];
    
    _leftFileBuffer = (Float32 *)calloc(inputFormat.frames, sizeof(Float32));
    _rightFileBuffer = (Float32 *)calloc(inputFormat.frames, sizeof(Float32));
    
    long samplesRead = sf_read_float(inputFile, fileBuffer, self.numberSamples);
    
    // de-interleave into two buffers
    for (int i = 0; i < (samplesRead / _numberChannels); ++i) {
        *(_leftFileBuffer+i) = fileBuffer[i*2];
        *(_rightFileBuffer+i) = fileBuffer[i*2+1];
    }
    sf_close(inputFile);
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
    for (int i = 0; i < inNumberFrames; i++) {
        *(leftBuffer+i) = *(_leftFileBuffer+_currentReadPosition) * cos(self.pan * M_PI_2) * self.volume;
        *(rightBuffer+i) = *(_rightFileBuffer+_currentReadPosition) * sin(self.pan * M_PI_2) * self.volume;
        long newReadPosition = _currentReadPosition + 1;
        self.currentReadPosition = newReadPosition % self.numberFrames;
    }
}

- (long)numberSamples {
    return _numberFrames * _numberChannels;
}

- (void)dealloc {
    free(_leftFileBuffer);
    free(_rightFileBuffer);
}

@end