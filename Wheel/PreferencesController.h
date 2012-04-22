//
//  Preferences.h
//  Wheel
//
//  Created by Alexander on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Preferences : NSWindowController <NSWindowDelegate>

@property (strong) IBOutlet NSToolbarItem *generalItem;
@property (strong) IBOutlet NSView *generalView;
@property (strong) IBOutlet NSView *libraryView;

- (IBAction)general:(id)sender;
- (IBAction)library:(id)sender;

@end
