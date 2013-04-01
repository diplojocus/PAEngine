//
//  MainViewController.h
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "PAController.h"

@interface MainViewController : NSViewController

@property (nonatomic, strong) PAController *audioController;

- (void)destroy;

- (IBAction)onProcessButton:(id)sender;

@end
