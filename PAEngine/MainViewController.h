//
//  MainViewController.h
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "PAController.h"

@class PASineGenerator;
@class PASamplePlayer;

@interface MainViewController : NSViewController

@property (nonatomic, strong) PAController *audioController;
@property (nonatomic, strong) PASamplePlayer *source;

- (void)destroy;

- (IBAction)onProcessButton:(id)sender;
- (IBAction)onPanSliderChange:(id)sender;
- (IBAction)onVolumeSliderChange:(id)sender;

@end
