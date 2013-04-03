//
//  PASource.h
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASource : NSObject

@property (nonatomic, assign) double startingFrameCount;

@property (nonatomic, assign) double frequency;

- (void)processBuffersLeft:(Float32 *)leftBuffer right:(Float32 *)rightBuffer withNumSamples:(UInt32)inNumSamples;

@end
