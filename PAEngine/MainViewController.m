//
//  MainViewController.m
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "MainViewController.h"

#import "PASineGenerator.h"
#import "PASamplePlayer.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
   
        self.audioController = [PAController sharedInstance];

//        self.sineGenerator = [[PASineGenerator alloc] sineGeneratorWithFrequency:440.0];
//        [self.sineGenerator setPan:0.5f];
//        [self.audioController addSoundSource:self.sineGenerator];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hihat" ofType:@"wav" inDirectory:@"samples"];
        self.source = [[PASamplePlayer alloc] init];
        [self.source openFileWithPath:filePath];
        [self.audioController addSoundSource:self.source];
    }
    return self;
}

- (IBAction)onProcessButton:(id)sender {
    ([sender state] == 1) ? [self.audioController start] : [self.audioController stop];
}

- (IBAction)onPanSliderChange:(id)sender {
    [self.source setPan:[sender floatValue]];
    
}

- (IBAction)onVolumeSliderChange:(id)sender {
    [self.source setVolume:[sender floatValue]];
}

- (void)destroy {
    [self.audioController destroy];
}

@end
