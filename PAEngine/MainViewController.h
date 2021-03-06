//
//  MainViewController.h
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "PAController.h"

@class PASource;

@interface MainViewController : NSViewController

@property (nonatomic, strong) PAController *audioController;
@property (nonatomic, strong) PASource *currentSource;
@property (strong) IBOutlet NSTextFieldCell *audioClipLabel;
@property (strong) IBOutlet NSButton *processButton;
@property (strong) IBOutlet NSSlider *panSlider;
@property (strong) IBOutlet NSSlider *volumeSlider;

- (void)destroy;

- (IBAction)onOpenAudioClipButton:(id)sender;

- (IBAction)onProcessButton:(id)sender;

- (IBAction)onPanSliderChange:(id)sender;

- (IBAction)onVolumeSliderChange:(id)sender;

@end