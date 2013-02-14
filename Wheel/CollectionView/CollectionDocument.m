//
//  CollectionDocument.m
//  Wheel
//
//  Created by Alexander on 13.02.13.
//
//

#import "CollectionDocument.h"

#import "Entity.h"
#import "CollectionController.h"

@implementation CollectionDocument

- (void)makeWindowControllers {
    CollectionController *windowController = [[CollectionController alloc] initWithWindowNibName:@"CollectionController"];
    [self addWindowController:windowController];
    
    if ([self.displayName isEqualToString:@"Untitled"]) {
        self.displayName = @"Window";
    }
    
    if (!self.rootEntity) {
        self.rootEntity = [[Entity outlineStub] representedObject];
        self.rootEntity.type = @"MyClass";
    }
    
    self.models = [NSMutableArray array];
    [self.models addObject:self.rootEntity];
    [self modelsWithEntity:self.rootEntity];
    self.models = self.models;
}

- (void)modelsWithEntity:(Entity *)entity {
    for (Entity *child in entity.children) {
        if (![child.kind isEqualToString:@"object"]) {
            [self.models addObject:child];
            [self modelsWithEntity:child];
        }
    }
}

- (IBAction)saveDocument:(id)sender {
    
}

@end
