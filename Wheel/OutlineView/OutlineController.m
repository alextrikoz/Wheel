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

@interface OutlineController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (strong) IBOutlet NSOutlineView *outlineView;

@property (strong) NSTreeNode *rootNode;
@property (strong) NSArray *draggedNodes;

@end

@implementation OutlineController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OutlineConfig" ofType:@"plist"]];
    
    self.rootNode = [self rootNodeWithDictionary:dictionary];
    
    [self.outlineView registerForDraggedTypes:@[@"OutlineEntity"]];
}

#pragma mark - NSOutlineViewDataSource, NSOutlineViewDelegate

- (NSArray *)childrenForItem:(NSTreeNode *)item {
    return (item == nil) ? self.rootNode.childNodes : item.childNodes;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return [self childrenForItem:item][index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [self childrenForItem:item].count;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [self childrenForItem:item].count;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    OutlineEntity *entity = [item representedObject];
    return entity.name;
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    self.draggedNodes = draggedItems;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
    [pboard setData:[NSData data] forType:@"OutlineEntity"];
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)ov acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {
    NSTreeNode *newParent = item == nil ? _rootNode : item;
    
    if (!newParent.childNodes.count) {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = 0;
        } else {
            childIndex = [newParent.parentNode.childNodes indexOfObject:newParent] + 1;
            newParent = [newParent parentNode];
        }
    } else {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = 0;
        }
    }
    
    [self.outlineView beginUpdates];
    
    __block NSInteger currentIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:self.outlineView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        NSTreeNode *draggedNode = self.draggedNodes[index];
        
        NSTreeNode *oldParent = draggedNode.parentNode;
        NSMutableArray *oldParentChildren = [oldParent mutableChildNodes];
        NSInteger oldIndex = [oldParentChildren indexOfObject:draggedNode];
        [oldParentChildren removeObjectAtIndex:oldIndex];
        [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:oldParent == self.rootNode ? nil : oldParent withAnimation:NSTableViewAnimationEffectFade];
        
        if (oldParent == newParent) {
            if (currentIndex > oldIndex) {
                currentIndex--;
            }
        }
        
        [newParent.mutableChildNodes insertObject:draggedNode atIndex:currentIndex];
        [self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] inParent:newParent == self.rootNode ? nil : newParent withAnimation:NSTableViewAnimationEffectFade];
        
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
    
    [self.outlineView endUpdates];
    
    return YES;
}

- (NSTreeNode *)rootNodeWithDictionary:(NSDictionary *)dictionary {
    OutlineEntity *entity = [OutlineEntity objectWithDictionary:dictionary];
    
    NSArray *children = [dictionary objectForKey:@"Children"];
    
    NSTreeNode *node = [NSTreeNode treeNodeWithRepresentedObject:entity];
    for (NSDictionary *child in children) {
        [node.mutableChildNodes addObject:[self rootNodeWithDictionary:child]];
    }
    return node;
}

@end
