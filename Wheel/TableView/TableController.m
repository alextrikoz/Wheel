//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"
#import "NSArray+NSIndexSet.h"
#import "NSIndexSet+NSArray.h"
#import <Carbon/Carbon.h>
#import "TableDocument.h"
#import "DataStore.h"
#import "Entity.h"
#import "ManagedUnit.h"

@interface TableController ()

- (TableDocument *)document;

@property IBOutlet NSTableView *tableView;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;

@property NSArray *draggedItems;

@end

@implementation TableController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"document.entities" context:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidRedoChangeNotification object:nil];
    [self addObserver:self forKeyPath:@"document.entities" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.tableView deselectAll:nil];
    [self.tableView registerForDraggedTypes:@[NSPasteboardTypeString]];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.document.className;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

- (TableDocument *)document {
    return [super document];
}

- (NSMutableArray *)entities {
    return self.document.entities;
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

#pragma mark - IBAction

- (IBAction)add:(id)sender {
    NSUInteger index = self.entities.count;
    if ([self.tableView selectedRowIndexes].count) {
        index = [[self.tableView selectedRowIndexes] lastIndex] + 1;
    }
    
    Entity *entity = [Entity objectStub];
    entity.undoManager = self.document.undoManager;
    
    [[self.document.undoManager prepareWithInvocationTarget:self.document] setEntities:self.entities.mutableCopy];
    
    [self.tableView beginUpdates];
    
    [self.entities insertObject:entity atIndex:index];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
    
    [self.tableView endUpdates];
}

- (IBAction)remove:(id)sender {
    if ([[self.tableView selectedRowIndexes] count] == 0) {
        return;
    }
    
    [[self.document.undoManager prepareWithInvocationTarget:self.document] setEntities:self.entities.mutableCopy];
    
    [self.tableView beginUpdates];
    
    [[self.tableView selectedRowIndexes] enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger row, BOOL *stop) {
        [self.entities removeObjectAtIndex:row];
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    }];
    
    [self.tableView endUpdates];
}

- (IBAction)generate:(id)sender {
    DataStore *dataStore = DataStore.sharedDataStore;
    NSString *h_content = [dataStore.HContentUnit bodyWithDocument:self.document pathExtension:@"h"];
    NSString *m_content = [dataStore.MContentUnit bodyWithDocument:self.document pathExtension:@"m"];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"Select";
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", directoryURL.absoluteString, self.document.className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", directoryURL.absoluteString, self.document.className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];

            [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

#pragma mark - NSTableViewDataSource

- (id <NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row {
    return self.entities[row];
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
    self.draggedItems = [self.entities objectsAtIndexes:rowIndexes];
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (self.draggedItems) {
        [[self.document.undoManager prepareWithInvocationTarget:self.document] setEntities:self.entities.mutableCopy];
        
        [self.tableView beginUpdates];
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (Entity *item in self.draggedItems) {
            [indexSet addIndex:[self.entities indexOfObject:item]];
        }
        
        [self.entities removeObjectsAtIndexes:indexSet];
        [self.tableView removeRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
        
        [self.tableView endUpdates];
        
        self.draggedItems = nil;
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return (dropOperation == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    [self.tableView beginUpdates];
    
    if ([info.draggingSource isEqual:self.tableView]) {
        [self acceptDropInsideWindow:info row:row];
    } else {
        [self acceptDropOutsideWindows:info row:row];
    }
    
    [self.tableView endUpdates];
    
    self.draggedItems = nil;
    
    return YES;
}

#pragma mark - AcceptDrop

- (void)acceptDropInsideWindow:(id <NSDraggingInfo>)info row:(NSInteger)row {
    [[self.document.undoManager prepareWithInvocationTarget:self.document] setEntities:self.entities.mutableCopy];
    
    __block NSInteger currentIndex = row;    
    [info enumerateDraggingItemsWithOptions:0 forView:self.tableView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        Entity *draggedItem = self.draggedItems[index];
        
        NSInteger oldIndex = [self.entities indexOfObject:draggedItem];
        [self.entities removeObjectAtIndex:oldIndex];
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] withAnimation:NSTableViewAnimationEffectFade];
        
        if (currentIndex > oldIndex) {
            currentIndex--;
        }
        
        [self.entities insertObject:draggedItem atIndex:currentIndex];
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] withAnimation:NSTableViewAnimationEffectGap];
        
        currentIndex++;
    }];
}

- (void)acceptDropOutsideWindows:(id <NSDraggingInfo>)info row:(NSInteger)row {
    [[self.document.undoManager prepareWithInvocationTarget:self.document] setEntities:self.entities.mutableCopy];
    
    __block NSInteger currentIndex = row;
    [info enumerateDraggingItemsWithOptions:0 forView:self.tableView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        Entity *entity = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingItem.item dataForType:NSPasteboardTypeString]];
        [self.entities insertObject:entity atIndex:row];
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectGap];
        
        currentIndex++;        
    }];
    
    [self.entities makeObjectsPerformSelector:@selector(setUndoManager:) withObject:self.document.undoManager];
}

@end
