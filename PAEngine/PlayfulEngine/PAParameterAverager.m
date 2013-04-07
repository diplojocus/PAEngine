//
//  PAParameterAverage.m
//  PAEngine
//
//  Created by Joe White on 07/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PAParameterAverager.h"

@implementation PAParameterAverager

- (id)init {
    self = [super init];
    if (self) {
        _a = 0.99f;
        _b = 1 - _a;
        _z = 0.0f;
    }
    return self;
}

- (float)process:(float)input {
    _z = (input * _b) + (_z * _a);
    return _z;
}

@end
