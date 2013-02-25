//
//  Preferences.h
//  Wheel
//
//  Created by Alexander on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataStore;

@interface PreferencesController : NSWindowController <NSWindowDelegate>

@property IBOutlet NSToolbarItem *generalItem;

@property IBOutlet NSView *generalView;
@property IBOutlet NSView *optionsView;

@property IBOutlet NSTableView *optionsTableView;

@property IBOutlet DataStore *dataStore;

- (IBAction)general:(id)sender;
- (IBAction)options:(id)sender;

@end
