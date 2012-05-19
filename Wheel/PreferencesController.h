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

@property (strong) IBOutlet NSToolbarItem *generalItem;
@property (strong) IBOutlet NSToolbarItem *libraryItem;
@property (strong) IBOutlet NSToolbarItem *optionsItem;
@property (strong) IBOutlet NSToolbarItem *addItem;
@property (strong) IBOutlet NSToolbarItem *removeItem;

@property (strong) IBOutlet NSView *generalView;
@property (strong) IBOutlet NSView *libraryView;
@property (strong) IBOutlet NSView *optionsView;

@property (strong) IBOutlet NSTableView *libraryTableView;
@property (strong) IBOutlet NSTableView *optionsTableView;

@property (strong) IBOutlet DataStore *dataStore;

- (IBAction)general:(id)sender;
- (IBAction)library:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)options:(id)sender;

@end
