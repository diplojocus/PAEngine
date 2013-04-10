//
//  PASamplePlayer.m
//  PAEngine
//
//  Created by Joe White on 03/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PAClipPlayer.h"
#include "sndfile.h"

@implementation PAClipPlayer

- (id)init {
    self = [super init];
    if (self) {
        _channelsArray = nil;
        _numberChannels = 0;
        _numberFrames = 0;
        _currentReadPosition = 0;
        _fileName = @"";
    }
    return self;
}

- (long)numberSamples {
    return _numberFrames * _numberChannels;
}

- (void)openFileWithPath:(NSString *)path {
    // Retrieve file info
    SF_INFO inputFormat = {0};
    SNDFILE *inputFile = sf_open([path cStringUsingEncoding:NSUTF8StringEncoding], SFM_READ, &inputFormat);
    _fileName = [path lastPathComponent];
    _numberChannels = MIN(inputFormat.channels, PAClipBufferChannelMax);
    _numberFrames = inputFormat.frames;
       
    // Load clip into temporary buffer;
    Float32 fileBuffer[self.numberSamples];
    long samplesRead = sf_read_float(inputFile, fileBuffer, self.numberSamples);
    
    // Allocate required number of buffers for channels
    _channelsArray = (Float32 **)calloc(_numberChannels, sizeof(Float32 *));
    for (int i = 0; i < _numberChannels; i++) {
        _channelsArray[i] = (Float32 *)calloc(_numberFrames, sizeof(Float32));
    }
    // De-interleave temporary buffer into channels
    for (int sampleIndex = 0; sampleIndex < (samplesRead / _numberChannels); ++sampleIndex) {
        for (PAClipBufferChannel channelNum = PAClipBufferChannelLeftOrMono; channelNum < _numberChannels; ++channelNum) {
            _channelsArray[channelNum][sampleIndex] = fileBuffer[(sampleIndex*_numberChannels)+channelNum];
        }
    }
    sf_close(inputFile);
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
    for (int i = 0; i < inNumberFrames; i++) {
        if (_numberChannels == 1) {
            *(leftBuffer+i) = _channelsArray[PAClipBufferChannelLeftOrMono][_currentReadPosition] * 0.5f;
            *(rightBuffer+i) = _channelsArray[PAClipBufferChannelLeftOrMono][_currentReadPosition] * 0.5f;
        } else {
            *(leftBuffer+i) = _channelsArray[PAClipBufferChannelLeftOrMono][_currentReadPosition];
            *(rightBuffer+i) = _channelsArray[PAClipBufferChannelRight][_currentReadPosition];
        }
        long newReadPosition = _currentReadPosition + 1;
        _currentReadPosition = newReadPosition % _numberFrames;
    }
}

- (void)dealloc {
    for (int i = 0; i < _numberChannels; i++) {
        free(_channelsArray[i]);
    }
    free(_channelsArray);
}

@end