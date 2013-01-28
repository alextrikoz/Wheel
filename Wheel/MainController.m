//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "NSArray+NSIndexSet.h"
#import "NSIndexSet+NSArray.h"
#import <Carbon/Carbon.h>
#import "Document.h"
#import "DataStore.h"
#import "Entity.h"
#import "ManagedUnit.h"

@implementation MainController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidRedoChangeNotification object:nil];
    
    [self.tableView deselectAll:nil];
    
    self.tableView.dataSource = self;
    [self.tableView registerForDraggedTypes:@[@"Entity"]];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return ((Document *)self.document).className;
}

- (Document *)document {
    return [super document];
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)add:(id)sender {
    [(Document *)self.document addEntity];
    [self.tableView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [(Document *)self.document removeSelectedEntities];
    [self.tableView deselectAll:nil];
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
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", directoryURL.absoluteString, ((Document *)self.document).className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", directoryURL.absoluteString, ((Document *)self.document).className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];

            [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

#pragma mark - NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [tableView selectRowIndexes:rowIndexes byExtendingSelection:YES];
    [self writeRowsWithIndexes:rowIndexes toPasteboard:pboard];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return (dropOperation == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    [self acceptDrop:info row:row];
    return YES;
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
    self.draggedItems = [((Document *)self.document).entities objectsAtIndexes:rowIndexes];
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    self.draggedItems = nil;
}

#pragma mark - Private

- (void)writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:@[@"Entity"] owner:nil];
    
    NSArray *objects = [((Document *)self.document).entities objectsAtIndexes:rowIndexes];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objects];
    [pboard setData:data forType:@"Entity"];
    
    self.sourceIndexes = rowIndexes;
}

- (void)acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row {
    [self.tableView beginUpdates];
    if ([info.draggingSource isEqual:self.tableView]) {
        [self acceptDropInsideWindow:info row:row];
    } else {
        [self acceptDropOutsideWindows:info row:row];
    }
    [self.tableView endUpdates];
}

- (void)acceptDropInsideWindow:(id <NSDraggingInfo>)info row:(NSInteger)row {    
    __block NSInteger currentIndex = row;
    [info enumerateDraggingItemsWithOptions:0 forView:self.tableView classes:@[[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        Entity *draggedItem = self.draggedItems[index];
        
        NSInteger oldIndex = [self.document.entities indexOfObject:draggedItem];
        [self.document.entities removeObjectAtIndex:oldIndex];
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] withAnimation:NSTableViewAnimationEffectFade];
        
        if (currentIndex > oldIndex) {
            currentIndex--;
        }
        
        [self.document.entities insertObject:draggedItem atIndex:currentIndex];
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:currentIndex] withAnimation:NSTableViewAnimationEffectFade];
    }];
}

- (void)acceptDropOutsideWindows:(id <NSDraggingInfo>)info row:(NSInteger)row {    
    NSPasteboard *pboard = info.draggingPasteboard;
    NSData *data = [pboard dataForType:@"Entity"];
    NSArray *objects = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *entities = ((Document *)self.document).entities.mutableCopy;
    [entities insertObjects:objects atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, [objects count])]];
    
    ((Document *)self.document).entities = entities;
}

@end
