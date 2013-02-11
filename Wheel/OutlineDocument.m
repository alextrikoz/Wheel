//
//  OutlineDocument.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineDocument.h"

#import "Entity.h"
#import "OutlineController.h"

@implementation OutlineDocument

@synthesize rootNode = _rootNode;

- (void)backupRootNode {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:[[Entity entityWithNode:self.rootNode] dictionaryRepresentation]];
}

- (void)backupRootNodeWithDictionary:(NSDictionary *)dictionary {
    [[self.undoManager prepareWithInvocationTarget:self] backupRootNodeWithDictionary:((Entity *)self.rootNode.representedObject).dictionaryRepresentation];
    
    self.rootNode = [Entity nodeWithDictionary:dictionary];
}

- (void)makeWindowControllers {
    OutlineController *windowController = [[OutlineController alloc] initWithWindowNibName:@"OutlineWnd"];
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
