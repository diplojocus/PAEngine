//
//  PASource.m
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASource.h"

@implementation PASource

- (void)processBuffersLeft:(Float32 *)leftBuffer right:(Float32 *)rightBuffer withNumSamples:(UInt32)numFrames {
    
    double j = self.startingFrameCount;
    double cycleLength = 44100.0 / self.frequency;
    int frame = 0;
    
    for (frame = 0; frame < numFrames; ++frame) {
        (leftBuffer)[frame] = (Float32)sin(2 * M_PI * (j / cycleLength));
        (rightBuffer)[frame] = (Float32)sin(2 * M_PI * (j / cycleLength));
        
        j += 1.0;
        if (j > cycleLength) {
            j -= cycleLength;
        }
    }
    self.startingFrameCount = j;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"source object"];
}

@end
