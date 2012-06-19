//
//  Document.m
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

#import "Entity.h"

#import "MainController.h"

@interface Document ()

- (NSMutableArray *)defaultEnities;

@end

@implementation Document

@synthesize className = _className;
@synthesize superClassName = _superClassName;
@synthesize entities = _entities;
@synthesize selectedEntities = _selectedEntities;

- (NSMutableArray *)defaultEnities {
    NSMutableArray *entities = [NSMutableArray array];
    
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [entities addObject:entity];
    
    return entities;        
}

- (void)addEntity {
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    self.entities = self.entities;
}

- (void)removeSelectedEntities {
    [self.entities removeObjectsAtIndexes:self.selectedEntities];
    self.entities = self.entities;
}

- (void)makeWindowControllers {
    MainController *windowController = [[MainController alloc] initWithWindowNibName:@"MainWnd"];
    [self addWindowController:windowController];
    
    if (!self.entities) {
        self.entities = self.defaultEnities;
    }
    if (!self.className) {
        self.className = @"MyClass";
    }
    if (!self.superClassName) {
        self.superClassName = @"NSObject";
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
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:self.entities forKey:@"entities"];
    [properties setObject:self.className forKey:@"className"];
    [properties setObject:self.superClassName forKey:@"superClassName"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:properties];
    
    return data;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    savePanel.nameFieldStringValue = self.className;  
    return [super prepareSavePanel:savePanel];
}

@end
