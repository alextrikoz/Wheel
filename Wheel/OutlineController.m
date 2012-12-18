//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import "OutlineEntity.h"
#import "OutlineDocument.h"
#import <Carbon/Carbon.h>

@implementation OutlineController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.outlineView deselectAll:nil];
    
    self.outlineView.dataSource = self;
    
    [self.outlineView registerForDraggedTypes:@[@"OutlineEntity"]];
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)addObject:(id)sender {
    [(OutlineDocument *)self.document addObject];
    [self.outlineView deselectAll:nil];
}

- (IBAction)addModel:(id)sender {
    [(OutlineDocument *)self.document addModel];
    [self.outlineView deselectAll:nil];
}

- (IBAction)addCollection:(id)sender {
    [(OutlineDocument *)self.document addCollection];
    [self.outlineView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [(OutlineDocument *)self.document removeSelectedEntities];
    [self.outlineView deselectAll:nil];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
    self.sourceNodes = items;
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:[items valueForKey:@"representedObject"]] forType:@"OutlineEntity"];
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(NSTreeNode *)item childIndex:(NSInteger)childIndex {
    if (childIndex == NSOutlineViewDropOnItemIndex) {
        childIndex = 0;
    }
    
    NSMutableArray *destinationChildren = item ? ((OutlineEntity *)item.representedObject).children : ((OutlineDocument *)self.document).entities;
    
    for (NSTreeNode *sourceNode in self.sourceNodes) {
        id representedObject = sourceNode.parentNode.representedObject;
        NSMutableArray *sourceChildren = [representedObject isKindOfClass:OutlineEntity.class] ? ((OutlineEntity *)representedObject).children : ((OutlineDocument *)self.document).entities;
        
        [sourceChildren removeObject:sourceNode.representedObject];
        
        [destinationChildren insertObject:sourceNode.representedObject atIndex:childIndex];
    }
    
    ((OutlineDocument *)self.document).entities = ((OutlineDocument *)self.document).entities;
    [self.outlineView deselectAll:nil];
    return YES;
}

@end
