//
//  AppDelegate.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) PreferencesController *preferencesController;

- (IBAction)preferences:(id)sender;
- (IBAction)newWheel:(id)sender;
- (IBAction)newOutline:(id)sender;
- (IBAction)newJSON:(id)sender;
- (IBAction)newCollection:(id)sender;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

- (NSURL *)applicationFilesDirectory;

@end
