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
    
    if (!self.className) {
        self.className = @"MyClass";
    }
    if (!self.superClassName) {
        self.superClassName = @"NSObject";
    }
    if (!self.rootEntity) {
        self.rootEntity = [Entity new];
        NSMutableArray *entities = [Entity plainStub];
        self.rootEntity.children = entities;
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    @try {
        NSDictionary *properties = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.rootEntity = [Entity objectWithDictionary:properties[@"rootEntity"]];
        self.className = properties[@"className"];
        self.superClassName = properties[@"superClassName"];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:[self.rootEntity dictionaryRepresentation] forKey:@"rootEntity"];
    [properties setObject:self.className forKey:@"className"];
    [properties setObject:self.superClassName forKey:@"superClassName"];
    return [NSKeyedArchiver archivedDataWithRootObject:properties];
}

- (NSString *)displayName {
    return self.rootEntity.className;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    savePanel.nameFieldStringValue = self.rootEntity.className;
    return [super prepareSavePanel:savePanel];
}

@end
