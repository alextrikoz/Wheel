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

@interface OutlineController ()

@property (strong) IBOutlet NSOutlineView *outlineView;

@property (strong) NSTreeNode *rootNode;
@property (strong) NSArray *sourceNodes;

@end

@implementation OutlineController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rootNode = [OutlineEntity rootNode];
    
    self.outlineView.dataSource = self;
    
    [self.outlineView registerForDraggedTypes:@[@"OutlineEntity"]];
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    self.sourceNodes = draggedItems;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
    [pboard setData:[NSData data] forType:@"OutlineEntity"];
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(NSTreeNode *)item childIndex:(NSInteger)childIndex {
    if (childIndex == NSOutlineViewDropOnItemIndex) {
        childIndex = 0;
    }
    
    [self.outlineView beginUpdates];
    
    NSTreeNode *newParent = item;
    
    NSMutableArray *childNodeArray = [newParent mutableChildNodes];
    
    __block NSInteger currentIndex = childIndex;
    
    [info enumerateDraggingItemsWithOptions:0 forView:self.outlineView classes:@[NSPasteboardItem.class] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        NSTreeNode *currentNode = self.sourceNodes[index];
        NSTreeNode *oldParent = [currentNode parentNode];
        NSMutableArray *oldParentChildren = [oldParent mutableChildNodes];
        NSInteger oldIndex = [oldParentChildren indexOfObject:currentNode];
        [oldParentChildren removeObjectAtIndex:oldIndex];
        [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:oldParent withAnimation:NSTableViewAnimationEffectNone];
        
        if (oldParent == newParent) {
            if (currentIndex > oldIndex) {
                currentIndex--;
            }
        }
        [childNodeArray insertObject:currentNode atIndex:currentIndex];
        
        [self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] inParent:newParent withAnimation:NSTableViewAnimationEffectGap];
        
        currentIndex++;
    }];
    
    [self.outlineView endUpdates];
    
    return YES;
}

@end
