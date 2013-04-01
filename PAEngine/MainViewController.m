//
//  MainViewController.m
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
   
        self.audioController = [[PAController alloc] init];
        [self.audioController addSource];
        // add sine wave generator object
        
        
    }
    return self;
}

- (IBAction)onProcessButton:(id)sender {
    ([sender state] == 1) ? [self.audioController start] : [self.audioController stop];
}

- (void)destroy {
    [self.audioController destroy];
}

@end
