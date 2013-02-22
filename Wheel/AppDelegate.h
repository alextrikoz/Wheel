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

@property (readonly) PreferencesController *preferencesController;

- (IBAction)preferences:(id)sender;
- (IBAction)newJSON:(id)sender;
- (IBAction)newXML:(id)sender;
- (IBAction)newOutline:(id)sender;
- (IBAction)newWheel:(id)sender;

@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

- (NSURL *)applicationFilesDirectory;

@end
