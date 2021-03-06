//
//  Preferences.m
//  Wheel
//
//  Created by Alexander on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"

#import <Carbon/Carbon.h>
#import "DataStore.h"

@interface PreferencesController ()

@property IBOutlet NSToolbarItem *generalItem;

@property IBOutlet NSView *generalView;
@property IBOutlet NSView *optionsView;
@property IBOutlet NSView *libraryView;

@property IBOutlet NSTableView *optionsTableView;
@property IBOutlet NSTableView *libraryTableView;

@property IBOutlet DataStore *dataStore;

- (IBAction)general:(id)sender;
- (IBAction)options:(id)sender;
- (IBAction)library:(id)sender;

@end

@implementation PreferencesController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self general:nil];
    self.window.toolbar.selectedItemIdentifier = self.generalItem.itemIdentifier;
    
    [self.optionsTableView deselectAll:nil];
    [self.libraryTableView deselectAll:nil];
}

- (IBAction)general:(id)sender {
    [self.window setContentView:self.generalView];
}

- (IBAction)options:(id)sender {
    [self.window setContentView:self.optionsView];
}

- (IBAction)library:(id)sender {
    [self.window setContentView:self.libraryView];
}

@end
