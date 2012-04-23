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
#import "AppDelegate.h"

@implementation PreferencesController

@synthesize generalItem = _generalItem;
@synthesize libraryItem = _libraryItem;

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
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSObject *";
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.dataStore.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
}

- (IBAction)remove:(id)sender {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    for (Type *type in self.dataStore.types) {
        if (type.checked.boolValue) {
            [appDelegate.managedObjectContext deleteObject:type];
        }
    }    
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.dataStore.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
}

@end
