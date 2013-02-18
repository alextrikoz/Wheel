//
//  Document.m
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableDocument.h"

#import "Entity.h"
#import "TableController.h"

@implementation TableDocument

- (void)backupRootEntity {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootEntityWithDictionary:self.rootEntity.dictionaryRepresentation];
}

- (void)backupRootEntityWithDictionary:(NSDictionary *)dictionary {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootEntityWithDictionary:self.rootEntity.dictionaryRepresentation];
    
    self.rootEntity = [Entity objectWithDictionary:dictionary];
}

#pragma mark - NSDocument

- (void)makeWindowControllers {
    TableController *windowController = [[TableController alloc] initWithWindowNibName:@"TableController"];
    [self addWindowController:windowController];
    
    if (!self.rootEntity) {
        self.rootEntity = [Entity new];
        self.rootEntity.className = @"MyClass";
        self.rootEntity.superClassName = @"NSObject";
        NSMutableArray *entities = [Entity plainStub];
        [entities makeObjectsPerformSelector:@selector(setUndoManager:) withObject:self.undoManager];
        self.rootEntity.children = entities;
        self.rootEntity.undoManager = self.undoManager;
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    @try {
        self.rootEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];        
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [NSKeyedArchiver archivedDataWithRootObject:self.rootEntity];
}

- (NSString *)displayName {
    return self.rootEntity.className;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    savePanel.nameFieldStringValue = self.rootEntity.className;
    return [super prepareSavePanel:savePanel];
}

@end
