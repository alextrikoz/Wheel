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

@implementation PreferencesController

@synthesize generalItem = _generalItem;
@synthesize addItem = _addItem;
@synthesize removeItem = _removeItem;

@synthesize generalView = _generalView;
@synthesize libraryView = _libraryView;
@synthesize optionsView = _optionsView;

@synthesize libraryTableView = _libraryTableView;
@synthesize optionsTableView = _optionsTableView;

@synthesize dataStore = _dataStore;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self general:nil];
    self.window.toolbar.selectedItemIdentifier = self.generalItem.itemIdentifier;
    
    [self.libraryTableView deselectAll:nil];
    [self.optionsTableView deselectAll:nil];
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)general:(id)sender {
    [self.window setContentView:self.generalView];
    
    NSUInteger index = [self.window.toolbar.items indexOfObject:self.addItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
    index = [self.window.toolbar.items indexOfObject:self.removeItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
}

- (IBAction)library:(id)sender {
    [self.window setContentView:self.libraryView];
    
    NSUInteger index = [self.window.toolbar.items indexOfObject:self.addItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.addItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
    index = [self.window.toolbar.items indexOfObject:self.removeItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.removeItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
}

- (IBAction)options:(id)sender {
    [self.window setContentView:self.optionsView];
    
    NSUInteger index = [self.window.toolbar.items indexOfObject:self.addItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
    index = [self.window.toolbar.items indexOfObject:self.removeItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
}

- (IBAction)add:(id)sender {
    [self.dataStore addType];
    [self.libraryTableView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [self.dataStore removeSelectedTypes];
    [self.libraryTableView deselectAll:nil];
}

@end
