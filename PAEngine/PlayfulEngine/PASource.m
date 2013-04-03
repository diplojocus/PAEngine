//
//  PASource.m
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASource.h"

@implementation PASource

- (id)init {
    self = [super init];
    if (self) {
        [self setPan:0.5f];
        [self setVolume:0.5f];
    }
    return self;
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
}

- (void)setPan:(float)pan {
    _pan = MIN(1.0f, pan);
    _pan = MAX(0.0f, _pan);
}

- (void)setVolume:(float)volume {
    _volume = MIN(1.0f, volume);
    _volume = MAX(0.0f, _volume);
}

@end
