//
//  Preferences.m
//  Wheel
//
//  Created by Alexander on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

@synthesize generalItem = _generalItem;
@synthesize generalView =_generalView;
@synthesize libraryView = _libraryView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self general:nil];
    self.window.toolbar.selectedItemIdentifier = self.generalItem.itemIdentifier;
}

- (IBAction)general:(id)sender {
    [self.window setContentView:self.generalView];
}

- (IBAction)library:(id)sender {
    [self.window setContentView:self.libraryView];    
}

@end
