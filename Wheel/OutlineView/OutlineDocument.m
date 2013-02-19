//
//  OutlineDocument.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineDocument.h"

#import "Entity.h"
#import "TableDocument.h"
#import "OutlineController.h"

@implementation OutlineDocument

- (void)backupRootNode {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[Entity dictionaryWithNode:self.rootNode]];
}

- (void)backupRootNodeWithDictionary:(NSDictionary *)dictionary {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[Entity dictionaryWithNode:self.rootNode]];
    
    self.rootNode = [Entity nodeWithDictionary:dictionary];
    
    [self updateModels];
}

- (void)makeWindowControllers {
    OutlineController *windowController = [[OutlineController alloc] initWithWindowNibName:@"OutlineController"];
    [self addWindowController:windowController];
    
    if (!self.className) {
        self.className = @"MyClass";
    }
    if (!self.superClassName) {
        self.superClassName = @"NSObject";
    }
    if (!self.rootNode) {
        self.rootNode = [Entity outlineStub];
    }
}

- (NSString *)displayName {
    return self.className;
}

- (void)updateModels {
    self.models = [NSMutableArray array];
    
    Entity *rootEntity = [Entity objectWithDictionary:[Entity dictionaryWithNode:self.rootNode]];
    rootEntity.className = self.className;
    rootEntity.superClassName = self.superClassName;
    
    [self.models addObject:rootEntity];
    [self modelsWithNode:self.rootNode];
    self.models = self.models;
}

- (void)modelsWithNode:(NSTreeNode *)node {
    for (NSTreeNode *childNode in node.childNodes) {
        Entity *childEntity = [Entity objectWithDictionary:[Entity dictionaryWithNode:childNode]];
        if (![childEntity.kind isEqualToString:@"object"]) {
            childEntity.superClassName = @"NSObject";
            [self.models addObject:childEntity];
            [self modelsWithNode:childNode];
        }
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:[Entity dictionaryWithNode:self.rootNode] forKey:@"rootNode"];
    [properties setObject:self.className forKey:@"className"];
    [properties setObject:self.superClassName forKey:@"superClassName"];
    return [NSKeyedArchiver archivedDataWithRootObject:properties];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    @try {
        NSDictionary *properties = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.rootNode = [Entity nodeWithDictionary:properties[@"rootNode"]];
        self.className = properties[@"className"];
        self.superClassName = properties[@"superClassName"];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

@end
