//
//  Document.m
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

#import "MainController.h"

@interface Document ()

@property (strong) NSArray *entities;

@end

@implementation Document

@synthesize entities = _entities;

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    MainController *viewController = self.windowControllers.lastObject;    
    savePanel.nameFieldStringValue = viewController.className;  
    return [super prepareSavePanel:savePanel];
}

- (void)makeWindowControllers {
    MainController *windowController = [[MainController alloc] initWithWindowNibName:@"MainWnd"];
    [self addWindowController:windowController];
    if (self.entities) {
        windowController.entities = [self.entities mutableCopy];
        self.entities = nil;
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    @try {
        self.entities = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    MainController *viewController = self.windowControllers.lastObject;
    NSArray *entities = viewController.entities;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:entities];
    return data;
}

@end
