//
//  PAParameterAverage.h
//  PAEngine
//
//  Created by Joe White on 07/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAParameterAverager : NSObject

@property (nonatomic, assign) float a;
@property (readonly, assign) float b;
@property (readonly, assign) float z;

- (float)process:(float)input;

@end
