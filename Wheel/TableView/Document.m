//
//  Document.m
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

#import "Entity.h"
#import "TableController.h"

@implementation Document

@synthesize className = _className;
- (void)setClassName:(NSString *)className {
    if (![_className isEqual:className]) {
        if (_className) {
            [self.undoManager registerUndoWithTarget:self selector:@selector(setClassName:) object:_className];
        }
        
        _className = className;
    }
}
- (NSString *)className {
    return _className;
}
@synthesize superClassName = _superClassName;
- (void)setSuperClassName:(NSString *)superClassName {
    if (![_superClassName isEqual:superClassName]) {
        if (_superClassName) {
            [self.undoManager registerUndoWithTarget:self selector:@selector(setSuperClassName:) object:_superClassName];
        }
        
        _superClassName = superClassName;
    }
}
- (NSString *)superClassName {
    return _superClassName;
}
@synthesize entities = _entities;
- (void)setEntities:(NSMutableArray *)entities {
    if (![_entities isEqual:entities]) {
        if (_entities) {
            [self.undoManager registerUndoWithTarget:self selector:@selector(setEntities:) object:_entities.mutableCopy];
        }
        
        _entities = entities;
    }
}
- (NSMutableArray *)entities {
    return _entities;
}

- (NSMutableArray *)defaultEnities {
    NSMutableArray *entities = [NSMutableArray array];
    
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    entity.undoManager = self.undoManager;
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    entity.undoManager = self.undoManager;
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    entity.undoManager = self.undoManager;
    [entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    entity.undoManager = self.undoManager;
    [entities addObject:entity];
    
    return entities;
}

- (void)makeWindowControllers {
    TableController *windowController = [[TableController alloc] initWithWindowNibName:@"TableWnd"];
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
    return [NSKeyedArchiver archivedDataWithRootObject:properties];
}

- (NSString *)displayName {
    return self.className;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    savePanel.nameFieldStringValue = self.className;
    return [super prepareSavePanel:savePanel];
}

@end
