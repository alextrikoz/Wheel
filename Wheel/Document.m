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

@property (strong) NSMutableArray *entities;
@property (copy) NSString *className;
@property (copy) NSString *superClassName;

@end

@implementation Document

@synthesize entities = _entities;
@synthesize className = _className;
@synthesize superClassName = _superClassName;

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    MainController *viewController = self.windowControllers.lastObject;    
    savePanel.nameFieldStringValue = viewController.className;  
    return [super prepareSavePanel:savePanel];
}

- (void)makeWindowControllers {
    MainController *windowController = [[MainController alloc] initWithWindowNibName:@"MainWnd"];
    [self addWindowController:windowController];
    if (self.entities) {
        windowController.entities = self.entities;
        windowController.className = self.className;
        windowController.superClassName = self.superClassName;
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    @try {
        NSDictionary *properties = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.entities = [[properties objectForKey:@"entities"] mutableCopy];
        self.className = [properties objectForKey:@"className"];
        self.superClassName = [properties objectForKey:@"superClassName"];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    MainController *viewController = self.windowControllers.lastObject;
    NSArray *entities = viewController.entities;
    NSString *className = viewController.className;
    NSString *superClassName = viewController.superClassName;
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:entities forKey:@"entities"];
    [properties setObject:className forKey:@"className"];
    [properties setObject:superClassName forKey:@"superClassName"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:properties];
    
    return data;
}

@end
