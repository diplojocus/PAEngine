//
//  AppDelegate.m
//  AETest
//
//  Created by Joe White on 31/03/2013.
//  Copyright (c) 2013 Joe White. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.window setContentView:[self.mainViewController view]];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    
    [self.mainViewController destroy];
}

@end
