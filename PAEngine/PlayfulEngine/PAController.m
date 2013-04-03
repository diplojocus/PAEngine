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

#define sineFrequency 440.0

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

OSStatus renderProc(
                    void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData) {
        
    PAController *audioController = (__bridge PAController *)(inRefCon);
    Float32 *leftBuffer = (Float32 *)ioData->mBuffers[0].mData;
    Float32 *rightBuffer = (Float32 *)ioData->mBuffers[1].mData;
    [audioController processLeftOutput:leftBuffer andRightOutput:rightBuffer withNumFrames:inNumberFrames];
    
    return noErr;
};

@implementation PAController

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
        input.inputProc = renderProc;
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

- (void)addSourceWithFrequency:(double)freq {
    PASource *newSource = [[PASource alloc] init];
    [newSource setFrequency:freq];
    [self.sourcesArray addObject:newSource];
}

- (void)processLeftOutput:(Float32 *)leftOutBuffer andRightOutput:(Float32 *)rightOutBuffer withNumFrames:(UInt32)numFrames {

    Float32 leftFrame[numFrames];
    Float32 rightFrame[numFrames];
    memset(leftFrame, 0, numFrames * sizeof(UInt32));
    memset(rightFrame, 0, numFrames * sizeof(UInt32));
    
    for (PASource *source in self.sourcesArray) {
        Float32 inputLeftFrame[numFrames];
        Float32 inputRightFrame[numFrames];
        
        [source processBuffersLeft:inputLeftFrame right:inputRightFrame withNumSamples:numFrames];

        for (int frame = 0; frame < numFrames; ++frame) {
            leftFrame[frame] += inputLeftFrame[frame];
            rightFrame[frame] += inputRightFrame[frame];
        }
        
    }
    memcpy(leftOutBuffer, leftFrame, numFrames * sizeof(UInt32));
    memcpy(rightOutBuffer, rightFrame, numFrames * sizeof(UInt32));
}

@end
