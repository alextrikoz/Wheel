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

#pragma mark - NSDocument

- (void)makeWindowControllers {
    OutlineController *windowController = [[OutlineController alloc] initWithWindowNibName:@"OutlineController"];
    [self addWindowController:windowController];
    
    if (!self.rootNode) {
        self.rootNode = [Entity outlineStub];
    }
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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"rootNode"] = [Entity dictionaryWithNode:self.rootNode];
    properties[@"className"] = self.className;
    properties[@"superClassName"] = self.superClassName;
    return [NSKeyedArchiver archivedDataWithRootObject:properties];
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    savePanel.nameFieldStringValue = self.className;
    return [super prepareSavePanel:savePanel];
}

- (NSString *)displayName {
    return self.className;
}

#pragma mark - 

- (void)setClassName:(NSString *)className {
    [self backupRootNode];
    ((Entity *)self.rootNode.representedObject).className = className;
}

- (NSString *)className {
    return ((Entity *)self.rootNode.representedObject).className;
}

- (void)setSuperClassName:(NSString *)superClassName {
    [self backupRootNode];
    ((Entity *)self.rootNode.representedObject).superClassName = superClassName;
}

- (NSString *)superClassName {
    return ((Entity *)self.rootNode.representedObject).superClassName;
}

- (void)backupRootNode {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[Entity dictionaryWithNode:self.rootNode]];
}

- (void)backupRootNodeWithDictionary:(NSDictionary *)dictionary {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[Entity dictionaryWithNode:self.rootNode]];
    
    self.rootNode = [Entity nodeWithDictionary:dictionary];
    ((Entity *)self.rootNode.representedObject).className = self.className;
    ((Entity *)self.rootNode.representedObject).superClassName = self.superClassName;
    
    [self updateModels];
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

+ (void)showWithEntity:(Entity *)entity {
    OutlineDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"outline" error:nil];
    document.rootNode = [Entity nodeWithDictionary:entity.dictionaryRepresentation];
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

@end
