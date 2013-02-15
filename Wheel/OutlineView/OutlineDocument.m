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
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[[Entity entityWithNode:self.rootNode] dictionaryRepresentation]];
}

- (void)backupRootNodeWithDictionary:(NSDictionary *)dictionary {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:((Entity *)self.rootNode.representedObject).dictionaryRepresentation];
    
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
    
    TableDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"wheel" error:nil];
    document.className = self.className;
    document.superClassName = self.superClassName;
    document.entities = ((Entity *)self.rootNode.representedObject).children;
    
    [self.models addObject:document];
    [self modelsWithEntity:self.rootNode.representedObject];
    self.models = self.models;
}

- (void)modelsWithEntity:(Entity *)entity {
    for (Entity *child in entity.children) {
        if (![child.kind isEqualToString:@"object"]) {
            TableDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"wheel" error:nil];
            document.className = child.className;
            document.superClassName = @"NSObject";
            document.entities = child.children;
            [self.models addObject:document];
            [self modelsWithEntity:child];
        }
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:[[Entity entityWithNode:self.rootNode] dictionaryRepresentation] forKey:@"rootNode"];
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
