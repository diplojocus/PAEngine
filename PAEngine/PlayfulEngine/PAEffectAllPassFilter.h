//
//  PAEffectAllPassFilter.h
//  PAEngine
//
//  Created by Joe White on 12/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAEffectAllPassFilter : NSObject

@property (nonatomic, assign) float delayTimeMs;
@property (nonatomic, assign) float rt60;

- (void)processLeftInput:(float *)inputL
           andRightInput:(float *)inputR
         inNumberSamples:(unsigned int)numSamples;

@end
