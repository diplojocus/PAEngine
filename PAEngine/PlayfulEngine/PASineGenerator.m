//
//  PASineGenerator.m
//  PAEngine
//
//  Created by Joe White on 03/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASineGenerator.h"

@implementation PASineGenerator

- (id)init {
    self = [super init];
    if (self) {
        // Defaults
        [self setFrequency:440.0];
    }
    return self;
}

- (id)sineGeneratorWithFrequency:(double)frequency {
    PASineGenerator *sineGenerator = [[PASineGenerator alloc] init];
    [self setFrequency:frequency];
    return sineGenerator;
}

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames {
    double j = self.startingFrameCount;
    double cycleLength = 44100.0 / self.frequency;
    
    for (int frame = 0; frame < inNumberFrames; ++frame) {
        Float32 sample = (Float32)sin(2 * M_PI * (j / cycleLength));
        leftBuffer[frame] = sample * cos(self.pan * M_PI_2) * self.volume;
        rightBuffer[frame] = sample * sin(self.pan * M_PI_2) * self.volume;
        
        j += 1.0;
        if (j > cycleLength) {
            j -= cycleLength;
        }
    }
    _startingFrameCount = j;
}

@end
