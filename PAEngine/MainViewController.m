//
//  MainViewController.m
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "MainViewController.h"

#import "PASineGenerator.h"
#import "PAClipPlayer.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.audioController = [PAController sharedInstance];
    }
    return self;
}

- (IBAction)onOpenAudioClipButton:(id)sender {
    
    [self.audioClipLabel setStringValue:@""];
    [self.audioController stop];
    [self.processButton setState:0];
    [self.audioController removeAllSoundSources];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [openPanel runModal];
    if (clicked == NSFileHandlingPanelOKButton) {
        NSURL *clipURL = [openPanel URL];
        [self.audioController addAudioClipFromURL:clipURL];
        [self.audioClipLabel setStringValue:[clipURL lastPathComponent]];
    }
}

- (IBAction)onProcessButton:(id)sender {
    ([sender state] == 1) ? [self.audioController start] : [self.audioController stop];
}

- (IBAction)onPanSliderChange:(id)sender {
//    [self.source setPan:[sender floatValue]];
    
}

- (IBAction)onVolumeSliderChange:(id)sender {
//    [self.source setVolume:[sender floatValue]];
}

- (void)destroy {
    [self.audioController destroy];
}

@end
