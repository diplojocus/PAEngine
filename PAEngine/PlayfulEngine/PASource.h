//
//  PASource.h
//  AETest
//
//  Created by Joe White on 01/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PASourceProtocol <NSObject>

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames;

@end

@interface PASource : NSObject {
    @protected double _startingFrameCount;
}

@property (readonly, nonatomic, strong) id <PASourceProtocol> sourceObject;
@property (readonly, nonatomic, assign) double startingFrameCount;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float pan;

- (void)setAudioClipWithURL:(NSURL *)clipURL;

- (void)processBuffersLeft:(Float32 *)leftBuffer
                     right:(Float32 *)rightBuffer
                 numFrames:(UInt32)inNumberFrames;

@end
