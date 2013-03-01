//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import <Carbon/Carbon.h>
#import "Entity.h"
#import "ManagedUnit.h"
#import "OutlineDocument.h"
#import "TableDocument.h"
#import "DataStore.h"
#import "CustomColumn.h"

@interface OutlineController () <NSOutlineViewDataSource, NSOutlineViewDelegate, NSCollectionViewDelegate>

- (OutlineDocument *)document;

@property IBOutlet NSOutlineView *outlineView;
@property IBOutlet NSTextField *classNameTextField;
@property IBOutlet NSTextField *superClassNameTextField;

@property IBOutlet NSView *outlinePleceholder;
@property IBOutlet NSView *collectionPleceholder;

@property IBOutlet NSToolbarItem *addItem;
@property IBOutlet NSToolbarItem *removeItem;
@property IBOutlet NSToolbarItem *generateItem;
@property IBOutlet NSToolbarItem *downloadItem;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;
- (IBAction)download:(id)sender;

@property NSArray *draggedNodes;

@end

@implementation OutlineController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"document.rootNode"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.outlineView deselectAll:nil];
    [self.outlineView registerForDraggedTypes:@[@"MyPasteboardType.wheel"]];
    
    [self addObserver:self forKeyPath:@"document.rootNode" options:NSKeyValueObservingOptionNew context:nil];
    
    for (int i = 0; i < self.outlineView.numberOfRows; i++) {
        [self.outlineView expandItem:[self.outlineView itemAtRow:i]];
    }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.document.className;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.outlineView reloadData];
    if (self.document.className) {
        [self.classNameTextField setStringValue:self.document.className];
    }
    if (self.document.superClassName) {
        [self.superClassNameTextField setStringValue:self.document.superClassName];
    }
}

- (OutlineDocument *)document {
    return [super document];
}

- (NSTreeNode *)rootNode {
    return self.document.rootNode;
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

#pragma mark - Actions

- (IBAction)add:(id)sender {
    Entity *entity = [Entity objectStub];
    entity.children = [NSMutableArray array];
    NSTreeNode *object = [NSTreeNode treeNodeWithRepresentedObject:entity];
    
    [self.document backupRootNode];
    
    [self.outlineView beginUpdates];
    
    NSTreeNode *selectedNode = self.rootNode.mutableChildNodes.lastObject;
    if (self.outlineView.selectedRowIndexes.count) {
        selectedNode = [self.outlineView itemAtRow:self.outlineView.selectedRowIndexes.lastIndex];
    }
    
    NSTreeNode *parentNode = selectedNode.parentNode;
    NSUInteger index = [parentNode.mutableChildNodes indexOfObject:selectedNode] + 1;
    
    [parentNode.mutableChildNodes insertObject:object atIndex:index];
    [((Entity *)parentNode.representedObject).children insertObject:object.representedObject atIndex:index];
    [self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentNode == self.rootNode ? nil : parentNode withAnimation:NSTableViewAnimationEffectFade];
    
    [self.outlineView endUpdates];
}

- (IBAction)remove:(id)sender {
    if (self.outlineView.selectedRowIndexes.count == 0) {
        return;
    }
    
    [self.document backupRootNode];
    
    [self.outlineView beginUpdates];
    
    [self.outlineView.selectedRowIndexes enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL *stop) {
        NSTreeNode *selectedNode = [self.outlineView itemAtRow:idx];
        NSTreeNode *parentNode = selectedNode.parentNode;
        NSUInteger index = [parentNode.mutableChildNodes indexOfObject:selectedNode];
        
        [parentNode.mutableChildNodes removeObjectAtIndex:index];
        [((Entity *)parentNode.representedObject).children removeObjectAtIndex:index];
        [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentNode == self.rootNode ? nil : parentNode withAnimation:NSTableViewAnimationEffectFade];
        
        if (parentNode.isLeaf) {
            [self.outlineView reloadItem:parentNode];
        }
    }];
    
    [self.outlineView endUpdates];
}

- (IBAction)generate:(id)sender {
    [self.document updateModels];
    
    [self.document.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [TableDocument showWithEntity:self.document.models[idx]];
    }];
}

- (IBAction)download:(id)sender {    
    [self.document updateModels];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"Select";
    openPanel.accessoryView = self.collectionPleceholder;
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            [self.document.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Entity *entity = self.document.models[idx];
                if (entity.enabled) {
                    [self saveEntity:entity directoryURL:directoryURL];
                }
            }];
        }
    }];
}

- (void)saveEntity:(Entity *)entity directoryURL:(NSURL *)directoryURL {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *h_content = [dataStore.HContentUnit bodyWithEntity:entity pathExtension:@"h"];
    NSString *m_content = [dataStore.MContentUnit bodyWithEntity:entity pathExtension:@"m"];
    
    NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", directoryURL.absoluteString, entity.className]];
    NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", directoryURL.absoluteString, entity.className]];
    
    [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
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

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(NSTreeNode *)item {    
    Entity *entity = [item representedObject];
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        return entity.name;
    } else if ([tableColumn.identifier isEqualToString:@"Key"]) {
        return entity.key;
    } else if ([tableColumn.identifier isEqualToString:@"Type"]) {
        if ([self customColumn:(CustomColumn *)tableColumn dataCellForRow:[self.outlineView rowForItem:item]] == POP_UP_BUTTON_CELL) {
            NSUInteger index = [[DataStore sharedDataStore].types indexOfObject:entity.type];
            if (index == NSNotFound) {
                index = 0;
            }
            return @(index);
        } else {
            return entity.type;
        }
    } else if ([tableColumn.identifier isEqualToString:@"Kind"]) {
        return @([[DataStore sharedDataStore].kinds indexOfObject:entity.kind]);
    } else if ([tableColumn.identifier isEqualToString:@"Setter"]) {
        return @([[DataStore sharedDataStore].setters indexOfObject:entity.setter]);
    } else if ([tableColumn.identifier isEqualToString:@"Atomicity"]) {
        return @([[DataStore sharedDataStore].atomicities indexOfObject:entity.atomicity]);
    } else {
        return @([[DataStore sharedDataStore].writabilities indexOfObject:entity.writability]);
    }
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(NSTreeNode *)item {
    [self.document backupRootNode];
    
    Entity *entity = [item representedObject];
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        entity.name = object;
    } else if ([tableColumn.identifier isEqualToString:@"Key"]) {
        entity.key = object;
    } else if ([tableColumn.identifier isEqualToString:@"Type"]) {
        if ([self customColumn:(CustomColumn *)tableColumn dataCellForRow:[self.outlineView rowForItem:item]] == POP_UP_BUTTON_CELL) {
            entity.type = DataStore.sharedDataStore.types[[object integerValue]];
        } else {
            entity.type = object;
        }
    } else if ([tableColumn.identifier isEqualToString:@"Kind"]) {
        NSString *oldKind = entity.kind;
        NSString *newKind = DataStore.sharedDataStore.kinds[[object integerValue]];
        if (![oldKind isEqualToString:@"object"] && [newKind isEqualToString:@"object"]) {
            NSUInteger index = [[DataStore sharedDataStore].types indexOfObject:entity.type];
            if (index == NSNotFound) {
                index = 0;
            }
            entity.type = [DataStore sharedDataStore].types[index];
        }
        [self.outlineView reloadData];
        entity.kind = newKind;
    } else if ([tableColumn.identifier isEqualToString:@"Setter"]) {
        entity.setter = DataStore.sharedDataStore.setters[[object integerValue]];
    } else if ([tableColumn.identifier isEqualToString:@"Atomicity"]) {
        entity.atomicity = DataStore.sharedDataStore.atomicities[[object integerValue]];
    } else {
        entity.writability = DataStore.sharedDataStore.writabilities[[object integerValue]];
    }
    
    [self.outlineView reloadItem:item reloadChildren:YES];
}

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item {
    return [item representedObject];
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    self.draggedNodes = draggedItems;
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (self.draggedNodes) {
        [self.document backupRootNode];
        
        [self.outlineView beginUpdates];
        
        [self.draggedNodes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTreeNode *obj, NSUInteger idx, BOOL *stop) {
            NSTreeNode *parentNode = obj.parentNode;
            NSUInteger index = [parentNode.mutableChildNodes indexOfObject:obj];
            [parentNode.mutableChildNodes removeObjectAtIndex:index];
            [((Entity *)parentNode.representedObject).children removeObjectAtIndex:index];
            [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentNode == self.rootNode ? nil : parentNode withAnimation:NSTableViewAnimationEffectFade];
            
            if (parentNode.isLeaf) {
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
    
    if (newParent.isLeaf) {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = 0;
        }
    } else {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            childIndex = newParent.childNodes.count;
        }
    }
    
    [self.document backupRootNode];
    
    [self.outlineView beginUpdates];
    
    if ([info.draggingSource isEqual:self.outlineView]) {
        [self acceptDropInsideWindow:info item:newParent childIndex:childIndex];
    } else {
        [self acceptDropOutsideWindow:info item:newParent childIndex:childIndex];
    }
    
    [self.outlineView endUpdates];
    
    return YES;
}

#pragma mark - AcceptDrop

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
            if (oldParent.isLeaf) {
                [self.outlineView reloadItem:oldParent];
            }
            if (!newParent.isLeaf) {
                [self.outlineView reloadItem:newParent];
            }
        }
    }];
    
    self.draggedNodes = nil;
}

- (void)acceptDropOutsideWindow:(id <NSDraggingInfo>)info item:(NSTreeNode *)newParent childIndex:(NSInteger)childIndex {    
    __block NSInteger currentIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:self.outlineView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        Entity *modelObject = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingItem.item dataForType:@"MyPasteboardType.wheel"]];
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

#pragma mark - CustomColumnDelegate

- (DATA_CELL)customColumn:(CustomColumn *)customColumn dataCellForRow:(NSInteger)row {
    if ([((Entity *)[[self.outlineView itemAtRow:row] representedObject]).kind isEqualToString:@"object"]) {
        return POP_UP_BUTTON_CELL;
    } else {
        return TEXT_FIELD_CELL;
    }
}

@end
