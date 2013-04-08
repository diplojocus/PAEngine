//
//  PAController.m
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>
#include <Accelerate/Accelerate.h>

#import "PAController.h"
#import "PASource.h"
#import "PAClipPlayer.h"
#import "PASineGenerator.h"

static void CheckResult(OSStatus result, const char *operation) {
    if (result == noErr) return;
    char errorString[20];
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else {
        sprintf(errorString, "%d", (int)result);
    }
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
    NSLog(@"%@", error);
    
    exit(1);
}

OSStatus renderCallback (
                    void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData) {
        
    PAController *audioController = (__bridge PAController *)(inRefCon);
    Float32 *leftBuffer = (Float32 *)ioData->mBuffers[0].mData;
    Float32 *rightBuffer = (Float32 *)ioData->mBuffers[1].mData;
    [audioController processBuffersLeft:leftBuffer right:rightBuffer numFrames:inNumberFrames];
    return noErr;
};

@implementation PAController

+ (PAController *)sharedInstance {
    static PAController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PAController alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sourcesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        // set up output unit and callback
        AudioComponentDescription outputcd = {0};
        outputcd.componentType = kAudioUnitType_Output;
        outputcd.componentSubType = kAudioUnitSubType_DefaultOutput;
        outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        AudioComponent comp = AudioComponentFindNext(NULL, &outputcd);
        if (comp == NULL) {
            printf("can't get output unit");
            exit(-1);
        }
        CheckResult(AudioComponentInstanceNew(comp,
                                              &_outputUnit),
                    "Couldn't open component for outputUnit");
        
        // Register the render callback
        AURenderCallbackStruct input;
        input.inputProc = renderCallback;
        input.inputProcRefCon = (__bridge void *)(self);
        
        CheckResult(AudioUnitSetProperty(_outputUnit,
                                         kAudioUnitProperty_SetRenderCallback,
                                         kAudioUnitScope_Input,
                                         0,
                                         &input,
                                         sizeof(input)),
                    "AudioUnitSetProperty failed");
        
        // Initialise the unit
        CheckResult(AudioUnitInitialize(_outputUnit),
                    "Couldn't initialise output unit");
        
    }
    return self;
}

- (void)destroy {
    AudioOutputUnitStop(_outputUnit);
    AudioUnitUninitialize(_outputUnit);
    AudioComponentInstanceDispose(_outputUnit);
}

- (void)start {
    AudioOutputUnitStart(_outputUnit);
}

- (void)stop {
    AudioOutputUnitStop(_outputUnit);
}

- (void)addSoundSource:(PASource *)sourceObject {
    [self.sourcesArray addObject:sourceObject];
}

- (void)removeAllSoundSources {
    [self.sourcesArray removeAllObjects];
}

- (void)addAudioClipFromURL:(NSURL *)clipURL {
    PAClipPlayer *newClipPlayer = [[PAClipPlayer alloc] init];
    [newClipPlayer openFileWithPath:[clipURL path]];
    [self.sourcesArray addObject:newClipPlayer];
}

- (void)processBuffersLeft:(Float32 *)leftBuffer right:(Float32 *)rightBuffer numFrames:(UInt32)inNumberFrames {
    Float32 leftSumBuffer[inNumberFrames];
    Float32 rightSumBuffer[inNumberFrames];
    memset(leftSumBuffer, 0, inNumberFrames * sizeof(UInt32));
    memset(rightSumBuffer, 0, inNumberFrames * sizeof(UInt32));
    
    for (PASource *source in self.sourcesArray) {
        Float32 leftSourceBuffer[inNumberFrames];
        Float32 rightSourceBuffer[inNumberFrames];
        
        [source processBuffersLeft:leftSourceBuffer right:rightSourceBuffer numFrames:inNumberFrames];
        
        vDSP_vadd(leftSumBuffer, 1, leftSourceBuffer, 1, leftSumBuffer, 1, inNumberFrames);
        vDSP_vadd(rightSumBuffer, 1, rightSourceBuffer, 1, rightSumBuffer, 1, inNumberFrames);
    }
    memcpy(leftBuffer, leftSumBuffer, inNumberFrames * sizeof(UInt32));
    memcpy(rightBuffer, rightSumBuffer, inNumberFrames * sizeof(UInt32));
}

@end