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

@interface OutlineController () <NSOutlineViewDataSource>

@property (strong) IBOutlet NSOutlineView *outlineView;

- (IBAction)addObject:(id)sender;
- (IBAction)addModel:(id)sender;
- (IBAction)addCollection:(id)sender;
- (IBAction)remove:(id)sender;

@end

@implementation OutlineController

@synthesize outlineView = _outlineView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.outlineView deselectAll:nil];
    
    self.outlineView.dataSource = self;
    
    [self.outlineView registerForDraggedTypes:[NSArray arrayWithObjects:@"OutlineEntity", @"OutlineEntityIndexPath", nil]];
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
    [pboard declareTypes:[NSArray arrayWithObjects:@"OutlineEntity", @"OutlineEntityIndexPath", nil] owner:nil];
    
    NSMutableArray *entities = [NSMutableArray array];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSTreeNode *node in items) {
        [entities addObject:node.representedObject];
        [indexPaths addObject:node.indexPath];
    }
    
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:entities] forType:@"OutlineEntity"];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:indexPaths] forType:@"OutlineEntityIndexPath"];
    
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {    
    NSPasteboard *pboard = [info draggingPasteboard];
    
    NSArray *sourceIndexesArray = [NSKeyedUnarchiver unarchiveObjectWithData:[pboard dataForType:@"OutlineEntityIndexPath"]];
    
    int decrement = 0;
    NSMutableArray *entities = ((OutlineDocument *)self.document).entities;
    for (long i = sourceIndexesArray.count - 1; i > -1; i--) {
        NSIndexPath *indexPath = [sourceIndexesArray objectAtIndex:i];
        if (indexPath.length == 1) {
            NSUInteger index = [indexPath indexAtPosition:i];
            [entities removeObjectAtIndex:index];
            if (index < childIndex && item == 0) {
                decrement++;
            }
            continue;
        }
        OutlineEntity *entity = nil;
        for (int i = 0; i < indexPath.length; i++) {
            NSUInteger index = [indexPath indexAtPosition:i];
            if (i == 0) {
                entity = [entities objectAtIndex:index];
            } else if (i == indexPath.length - 1) {
                [entity.children removeObjectAtIndex:index];
                if (index < childIndex && [entity isEqual:[item representedObject]]) {
                    decrement++;
                }
            } else {
                entity = [entity.children objectAtIndex:index];
            }
        }
    }
    childIndex -= decrement;
    
    if (childIndex == NSOutlineViewDropOnItemIndex) {
        childIndex = 0;
    }
    
    NSArray *sourceObjects = [NSKeyedUnarchiver unarchiveObjectWithData:[pboard dataForType:@"OutlineEntity"]];
    NSIndexSet *destinationIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(childIndex--, [sourceIndexesArray count])];
    
    if (item) {
        [[(OutlineEntity *)[item representedObject] children] insertObjects:sourceObjects atIndexes:destinationIndexes];
    } else {
        [entities insertObjects:sourceObjects atIndexes:destinationIndexes];
    }
    
    ((OutlineDocument *)self.document).entities = ((OutlineDocument *)self.document).entities;
    [self.outlineView deselectAll:nil];
    
    return YES;
}

@end
