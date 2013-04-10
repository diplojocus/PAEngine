//
//  PAParameterAverage.h
//  PAEngine
//
//  Created by Joe White on 07/04/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAParameterAverager : NSObject

@property (readonly, nonatomic, assign) float a;
@property (readonly, nonatomic, assign) float b;
@property (readonly, nonatomic, assign) float z;

- (float)process:(float)input;

- (void)setAlpha:(float)newAlpha;

@end
