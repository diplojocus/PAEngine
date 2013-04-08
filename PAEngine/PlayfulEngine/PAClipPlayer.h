//
//  PASamplePlayer.h
//  PAEngine
//
//  Created by Joe White on 03/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASource.h"

typedef enum {
    PAClipBufferChannelLeftOrMono = 0,
    PAClipBufferChannelRight = 1,
    PAClipBufferChannelMax
} PAClipBufferChannel;

@interface PAClipPlayer : PASource

@property (readonly, nonatomic) long numberFrames;
@property (readonly, nonatomic) int numberChannels;
@property (readonly, nonatomic) Float32 *leftOrMonoFileBuffer;
@property (readonly, nonatomic) Float32 *rightFileBuffer;
@property (readonly, nonatomic) Float32 **channelsArray;
@property (nonatomic, assign) long currentReadPosition;

- (void)openFileWithPath:(NSString *)path;

- (long)numberSamples;

@end
