//
//  PASineGenerator.h
//  PAEngine
//
//  Created by Joe White on 03/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "PASource.h"

@interface PASineGenerator : PASource

@property (nonatomic, assign) double frequency;

- (id)sineGeneratorWithFrequency:(double)frequency;

@end
