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

@interface PAClipPlayer : NSObject <PASourceProtocol>

@property (readonly, nonatomic) Float32 **channelsArray;
@property (readonly, nonatomic) int numberChannels;
@property (readonly, nonatomic) long numberFrames;
@property (readonly, nonatomic) long currentReadPosition;
@property (readonly, nonatomic) NSString *fileName;

- (long)numberSamples;

- (void)openFileWithPath:(NSString *)path;

@end
