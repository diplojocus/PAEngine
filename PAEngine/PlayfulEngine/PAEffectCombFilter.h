//
//  PAEffectCombFilter.h
//  PAEngine
//
//  Created by Joe White on 10/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAEffectCombFilter : NSObject

@property (nonatomic, assign) float delayTimeMs;

- (void)processLeftInput:(const float *)inputL
           andRightInput:(const float *)inputR
            toLeftOutput:(float *)outputL
          andRightOutput:(float *)outputR
         inNumberSamples:(unsigned int)numSamples;

@end
