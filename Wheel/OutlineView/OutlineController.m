//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import "Entity.h"
#import "OutlineDocument.h"
#import <Carbon/Carbon.h>

@interface OutlineController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (strong) IBOutlet NSOutlineView *outlineView;

@property (strong) NSTreeNode *rootNode;
@property (strong) NSArray *draggedNodes;

@end

@implementation OutlineController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OutlineConfig" ofType:@"plist"]];
    
    self.rootNode = [Entity nodeWithDictionary:dictionary];
    
    [self.outlineView registerForDraggedTypes:@[@"Entity", NSPasteboardTypeString]];
}

#pragma mark - NSOutlineViewDataSource, NSOutlineViewDelegate

- (NSArray *)childrenForItem:(NSTreeNode *)item {
    return (item == nil) ? self.rootNode.childNodes : item.childNodes;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [self childrenForItem:item].count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return [self childrenForItem:item][index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [self childrenForItem:item].count;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    Entity *entity = [item representedObject];
    if ([tableColumn.identifier isEqualToString:@"Setter"]) {
        return entity.setter;
    } else if ([tableColumn.identifier isEqualToString:@"Atomicity"]) {
        return entity.atomicity;
    } else if ([tableColumn.identifier isEqualToString:@"Writability"]) {
        return entity.writability;
    } else if ([tableColumn.identifier isEqualToString:@"Type"]) {
        return entity.type;
    } else {
        return entity.name;
    }
}

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item {
    return [item representedObject];
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    self.draggedNodes = draggedItems;
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (self.draggedNodes) {
        [self.outlineView beginUpdates];
        
        [self.draggedNodes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTreeNode *obj, NSUInteger idx, BOOL *stop) {
            NSTreeNode *parentNode = obj.parentNode;
            NSUInteger index = [parentNode.mutableChildNodes indexOfObject:obj];
            [parentNode.mutableChildNodes removeObjectAtIndex:index];
            [((Entity *)parentNode.representedObject).children removeObjectAtIndex:index];
            [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentNode == self.rootNode ? nil : parentNode withAnimation:NSTableViewAnimationEffectFade];
            
            if (!parentNode.childNodes.count) {
                [self.outlineView reloadItem:parentNode];
            }
        }];
        
        [self.outlineView endUpdates];
        
        self.draggedNodes = nil;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {
    NSTreeNode *newParent = item == nil ? self.rootNode : item;
    
    if (!newParent.childNodes.count) {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = 0;
        }
    } else {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = newParent.childNodes.count;
        }
    }
    
    [self.outlineView beginUpdates];
    
    if ([info.draggingSource isEqual:self.outlineView]) {
        [self acceptDropInsideWindow:info item:newParent childIndex:childIndex];
    } else {
        [self acceptDropOutsideWindow:info item:newParent childIndex:childIndex];
    }
    
    [self.outlineView endUpdates];
    
    return YES;
}

- (void)acceptDropInsideWindow:(id <NSDraggingInfo>)info item:(NSTreeNode *)newParent childIndex:(NSInteger)childIndex {
    __block NSInteger currentIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:self.outlineView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        NSTreeNode *draggedNode = self.draggedNodes[index];
        
        if (draggedNode == newParent || draggedNode == newParent.parentNode) {
            return;
        }
        
        NSTreeNode *oldParent = draggedNode.parentNode;
        NSMutableArray *oldParentChildren = oldParent.mutableChildNodes;
        NSInteger oldIndex = [oldParentChildren indexOfObject:draggedNode];
        [oldParentChildren removeObjectAtIndex:oldIndex];
        [((Entity *)oldParent.representedObject).children removeObjectAtIndex:oldIndex];
        [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:oldParent == self.rootNode ? nil : oldParent withAnimation:NSTableViewAnimationEffectFade];
        
        if (oldParent == newParent) {
            if (currentIndex > oldIndex) {
                currentIndex--;
            }
        }
        
        [newParent.mutableChildNodes insertObject:draggedNode atIndex:currentIndex];
        [((Entity *)newParent.representedObject).children insertObject:draggedNode.representedObject atIndex:currentIndex];
        [self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] inParent:newParent == self.rootNode ? nil : newParent withAnimation:NSTableViewAnimationEffectGap];
        
        currentIndex++;
        
        if (oldParent != newParent) {
            if (!oldParent.childNodes.count) {
                [self.outlineView reloadItem:oldParent];
            }
            if (newParent.childNodes.count) {
                [self.outlineView reloadItem:newParent];
            }
        }
    }];
    
    self.draggedNodes = nil;
}

- (void)acceptDropOutsideWindow:(id <NSDraggingInfo>)info item:(NSTreeNode *)newParent childIndex:(NSInteger)childIndex {    
    __block NSInteger currentIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:self.outlineView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        Entity *modelObject = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingItem.item dataForType:NSPasteboardTypeString]];
        NSTreeNode *draggedNode = [Entity nodeWithDictionary:modelObject.dictionaryRepresentation];
        
        [newParent.mutableChildNodes insertObject:draggedNode atIndex:currentIndex];
        [((Entity *)newParent.representedObject).children insertObject:draggedNode.representedObject atIndex:currentIndex];
        [self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] inParent:newParent == self.rootNode ? nil : newParent withAnimation:NSTableViewAnimationEffectGap];
        
        currentIndex++;
        
        if (newParent.childNodes.count) {
            [self.outlineView reloadItem:newParent];
        }
    }];
}

@end
