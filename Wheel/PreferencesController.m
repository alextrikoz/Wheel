//
//  Preferences.m
//  Wheel
//
//  Created by Alexander on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"

#import "Type.h"
#import "DataStore.h"

@implementation PreferencesController

@synthesize generalItem = _generalItem;
@synthesize generalView =_generalView;
@synthesize libraryView = _libraryView;

@synthesize dataStore = _dataStore;

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

- (IBAction)add:(id)sender {
    Type *type = [[Type alloc] init];
    [type setChecked:[NSNumber numberWithBool:YES]];
    [type setName:@"NSObject *"];
    [self.dataStore.types addObject:type];
    
    self.dataStore.types = self.dataStore.types;
}

- (IBAction)remove:(id)sender {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.dataStore.types.count];
    for (Type *type in self.dataStore.types) {
        if (!type.checked.boolValue) {
            [temp addObject:type];
        }
    }
    self.dataStore.types = temp;
}

@end
