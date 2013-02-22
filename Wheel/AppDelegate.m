//
//  AppDelegate.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "PreferencesController.h"
#import "TableDocument.h"
#import "OutlineDocument.h"

@implementation AppDelegate

@synthesize preferencesController = _preferencesController;
- (PreferencesController *)preferencesController {
    if(!_preferencesController) {
        _preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"PreferencesController"];
    }
    return _preferencesController;
}

- (void)setupDefaults {
    NSMutableDictionary *initialValues = [NSMutableDictionary dictionary];
    [initialValues setValue:@"__MyName__" forKey:@"MyName"];
    [initialValues setValue:@"__MyCompanyName__" forKey:@"MyCompanyName"];
    [initialValues setValue:@"__MyProjectName__" forKey:@"MyProjectName"];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
}

- (void)removeStoreIfNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults objectForKey:@"version"];
    if (![version isEqualToString:@"15"]) {
        [defaults setValue:@"15" forKey:@"version"];
        [defaults synchronize];
        [[NSFileManager defaultManager] removeItemAtURL:[self.applicationFilesDirectory URLByAppendingPathComponent:@"Wheel.storedata"] error:nil];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupDefaults];
    
    NSDocumentController *sharedDocumentController = NSDocumentController.sharedDocumentController;
    NSArray *documents = [sharedDocumentController documents];
    if (!documents.count) {
        [self newJSON:nil];
    }
    
    [NSApplication.sharedApplication.windows makeObjectsPerformSelector:@selector(orderFront:)];
}

- (IBAction)preferences:(id)sender {
    [self.preferencesController.window makeKeyAndOrderFront:nil];
}

- (IBAction)newJSON:(id)sender {
    [self makeAndDisplayUntitledDocumentOfType:@"json"];
}

- (IBAction)newXML:(id)sender {
    [self makeAndDisplayUntitledDocumentOfType:@"xml"];
}

- (IBAction)newOutline:(id)sender {
    [self makeAndDisplayUntitledDocumentOfType:@"outline"];
}

- (IBAction)newWheel:(id)sender {
    [self makeAndDisplayUntitledDocumentOfType:@"wheel"];
}

- (void)makeAndDisplayUntitledDocumentOfType:(NSString *)typeName {
    NSDocumentController *sharedDocumentController = NSDocumentController.sharedDocumentController;
    NSDocument *document = [sharedDocumentController makeUntitledDocumentOfType:typeName error:nil];
    [sharedDocumentController addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Wheel" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"Wheel"];
}

/**
    Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Wheel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([properties[NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Wheel.storedata"];
    
    [self removeStoreIfNeeded];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = coordinator;
    
    return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.)
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    if (self.preferencesController.window.isVisible) {
        [self.preferencesController.window close];
    }
    
    // Save changes in the application's managed object context before the application terminates.
    
    if (!__managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

@end
