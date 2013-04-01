//
//  PAController.h
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface PAController : NSObject

@property (nonatomic, assign) AudioUnit outputUnit;
@property (nonatomic, assign) double startingFrameCount;
@property (nonatomic, strong) NSMutableArray *sourcesArray;

- (id)init;

- (void)destroy;

- (void)start;

- (void)stop;

- (void)addSource;

- (void)processLeftOutput:(Float32 *)leftOutBuffer andRightOutput:(Float32 *)rightOutBuffer withNumFrames:(UInt32)numFrames;

@end
