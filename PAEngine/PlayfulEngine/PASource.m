//
//  PASource.m
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASource.h"
#import "PAParameterAverager.h"

@implementation PASource {
    PAParameterAverager *panAverager;
    PAParameterAverager *volumeAverager;
}

@synthesize pan;
@synthesize volume;

- (id)init {
    self = [super init];
    if (self) {
        
        panAverager = [[PAParameterAverager alloc] init];
        volumeAverager = [[PAParameterAverager alloc] init];
        
        [self setPan:0.5f];
        [self setVolume:0.5f];
    }
    return self;
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
}

- (void)setPan:(float)newPan {
    pan = MIN(1.0f, newPan);
    pan = MAX(0.0f, pan);
}

- (float)pan {
    return [panAverager process:pan];
}

- (void)setVolume:(float)newVolume {
    volume = MIN(1.0f, newVolume);
    volume = MAX(0.0f, volume);
}

- (float)volume {
    return [volumeAverager process:volume];
}

@end