//
//  PAController.h
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@class PASource;

@interface PAController : NSObject

@property (nonatomic, assign) AudioUnit outputUnit;
@property (nonatomic, assign) double startingFrameCount;
@property (nonatomic, strong) NSMutableArray *sourcesArray;

+ (PAController *)sharedInstance;

- (void)destroy;

- (void)start;

- (void)stop;

- (PASource *)addAudioClipFromURL:(NSURL *)clipURL;

- (void)removeAllSoundSources;

- (void)processBuffersLeft:(Float32 *)leftBuffer right:(Float32 *)rightBuffer numFrames:(UInt32)inNumberFrames;

@end
