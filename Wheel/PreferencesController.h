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
@property IBOutlet NSToolbarItem *addItem;
@property IBOutlet NSToolbarItem *removeItem;

@property IBOutlet NSView *generalView;
@property IBOutlet NSView *libraryView;
@property IBOutlet NSView *optionsView;

@property IBOutlet NSTableView *libraryTableView;
@property IBOutlet NSTableView *optionsTableView;

@property IBOutlet DataStore *dataStore;

- (IBAction)general:(id)sender;
- (IBAction)library:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)options:(id)sender;

@end
