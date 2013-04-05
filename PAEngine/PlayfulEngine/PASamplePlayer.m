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
        _lengthInSamples = 0;
        [self setCurrentReadPosition:0];
        [self setPan:0.5];
        [self setVolume:0.5];
    }
    return self;
}

- (void)openFileWithPath:(NSString *)path {
    SF_INFO inputFormat = {0};
    SNDFILE *inputFile = sf_open([path cStringUsingEncoding:NSUTF8StringEncoding], SFM_READ, &inputFormat);
    
    _lengthInSamples = inputFormat.frames * inputFormat.channels;
    
    Float32 fileBuffer[(inputFormat.frames * inputFormat.channels)];
    _leftFileBuffer = (Float32 *)malloc((sizeof(Float32) * inputFormat.frames));
    _rightFileBuffer = (Float32 *)malloc((sizeof(Float32) * inputFormat.frames));
    
    long samplesRead = sf_read_float(inputFile, fileBuffer, (inputFormat.frames * inputFormat.channels));
    
    // de-interleave into two buffers
    for (int i = 0; i < (samplesRead / inputFormat.channels); ++i) {
        *(_leftFileBuffer+i) = fileBuffer[i*2];
        *(_rightFileBuffer+i) = fileBuffer[i*2+1];
    }
    sf_close(inputFile);
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
    for (int i = 0; i < inNumberFrames; i++) {
        *(leftBuffer+self.currentReadPosition) = *(_leftFileBuffer+self.currentReadPosition);
        *(rightBuffer+self.currentReadPosition) = *(_rightFileBuffer+self.currentReadPosition);
        long newReadPosition = self.currentReadPosition + 1;
        self.currentReadPosition = newReadPosition % self.lengthInSamples;
    }
}

- (void)dealloc {
    free(_leftFileBuffer);
    free(_rightFileBuffer);
}

@end
