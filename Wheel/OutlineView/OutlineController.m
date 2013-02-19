//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import "Entity.h"
#import "ManagedUnit.h"
#import "TableDocument.h"
#import "OutlineDocument.h"
#import "DataStore.h"
#import <Carbon/Carbon.h>

@interface OutlineController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

- (OutlineDocument *)document;

@property IBOutlet NSOutlineView *outlineView;
@property IBOutlet NSCollectionView *collectionView;

@property IBOutlet NSView *placeholder;
@property IBOutlet NSView *outlinePleceholder;
@property IBOutlet NSView *collectionPleceholder;

@property IBOutlet NSToolbarItem *outlineItem;
@property IBOutlet NSToolbarItem *collectionItem;
@property IBOutlet NSToolbarItem *addItem;
@property IBOutlet NSToolbarItem *removeItem;
@property IBOutlet NSToolbarItem *generateItem;
@property IBOutlet NSToolbarItem *downloadItem;

- (IBAction)outline:(id)sender;
- (IBAction)collection:(id)sender;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;

@property (strong) NSArray *draggedNodes;

@end

@implementation OutlineController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"document.rootNode"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.outlineView deselectAll:nil];
    [self.outlineView registerForDraggedTypes:@[NSPasteboardTypeString]];
    
    [self addObserver:self forKeyPath:@"document.rootNode" options:NSKeyValueObservingOptionNew context:nil];
    
    for (int i = 0; i < self.outlineView.numberOfRows; i++) {
        [self.outlineView expandItem:[self.outlineView itemAtRow:i]];
    }
    
    [self outline:self.outlineItem];
    self.window.toolbar.selectedItemIdentifier = self.outlineItem.itemIdentifier;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.document.className;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.outlineView reloadData];
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
    [self.collectionView.selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self showEntity:[self.document.models objectAtIndex:idx]];
    }];
}

- (void)showEntity:(Entity *)entity {
    TableDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"wheel" error:nil];
    document.className = entity.className;
    document.superClassName = entity.superClassName;
    document.rootEntity = entity;
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

- (IBAction)download:(id)sender {
    if (!self.collectionView.selectionIndexes.count) {
        return;
    }
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"Select";
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            [self.collectionView.selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [self saveEntity:self.document.models[idx] directoryURL:directoryURL];
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

- (IBAction)outline:(id)sender {
    if (self.outlinePleceholder.superview) {
        return;
    }
    
    [self.collectionPleceholder removeFromSuperview];
    self.outlinePleceholder.frame = self.placeholder.bounds;
    [self.placeholder addSubview:self.outlinePleceholder];
    
    NSUInteger index = [self.window.toolbar.items indexOfObject:self.addItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.addItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
    index = [self.window.toolbar.items indexOfObject:self.removeItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.removeItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
    index = [self.window.toolbar.items indexOfObject:self.generateItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
    index = [self.window.toolbar.items indexOfObject:self.downloadItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
}

- (IBAction)collection:(id)sender {
    if (self.collectionPleceholder.superview) {
        return;
    }
    
    [self.outlinePleceholder removeFromSuperview];
    self.collectionPleceholder.frame = self.placeholder.bounds;
    [self.placeholder addSubview:self.collectionPleceholder];
    [self.document updateModels];
    
    NSUInteger index = [self.window.toolbar.items indexOfObject:self.addItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
    index = [self.window.toolbar.items indexOfObject:self.removeItem];
    if (index != NSNotFound) {
        [self.window.toolbar removeItemAtIndex:index];
    }
    index = [self.window.toolbar.items indexOfObject:self.generateItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.generateItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
    index = [self.window.toolbar.items indexOfObject:self.downloadItem];
    if (index == NSNotFound) {
        [self.window.toolbar insertItemWithItemIdentifier:self.downloadItem.itemIdentifier atIndex:self.window.toolbar.items.count];
    }
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
        NSUInteger index = [[[DataStore sharedDataStore].types valueForKey:@"name"] indexOfObject:entity.type];
        return [NSNumber numberWithInteger:index];
    } else if ([tableColumn.identifier isEqualToString:@"Kind"]) {
        NSUInteger index = [[DataStore sharedDataStore].kinds indexOfObject:entity.kind];
        return [NSNumber numberWithInteger:index];
    } else if ([tableColumn.identifier isEqualToString:@"Setter"]) {
        NSUInteger index = [[DataStore sharedDataStore].setters indexOfObject:entity.setter];
        return [NSNumber numberWithInteger:index];
    } else if ([tableColumn.identifier isEqualToString:@"Atomicity"]) {
        NSUInteger index = [[DataStore sharedDataStore].atomicities indexOfObject:entity.atomicity];
        return [NSNumber numberWithInteger:index];
    } else {
        NSUInteger index = [[DataStore sharedDataStore].writabilities indexOfObject:entity.writability];
        return [NSNumber numberWithInteger:index];
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
        entity.type = [[[DataStore sharedDataStore].types valueForKey:@"name"] objectAtIndex:[object integerValue]];
    } else if ([tableColumn.identifier isEqualToString:@"Kind"]) {
        entity.kind = [[DataStore sharedDataStore].kinds objectAtIndex:[object integerValue]];
    } else if ([tableColumn.identifier isEqualToString:@"Setter"]) {
        entity.setter = [[DataStore sharedDataStore].setters objectAtIndex:[object integerValue]];
    } else if ([tableColumn.identifier isEqualToString:@"Atomicity"]) {
        entity.atomicity = [[DataStore sharedDataStore].atomicities objectAtIndex:[object integerValue]];
    } else {
        entity.writability = [[DataStore sharedDataStore].writabilities objectAtIndex:[object integerValue]];
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
