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

@synthesize tableView = _tableView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:NSUndoManagerDidRedoChangeNotification object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(deselectAll:) name:NSUndoManagerDidRedoChangeNotification object:nil];
    
    [self.tableView deselectAll:nil];
    
    self.tableView.dataSource = self;
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:@"Entity"]];
    
    self.collectionView.delegate = self;
    [self.collectionView registerForDraggedTypes:[NSArray arrayWithObject:@"Entity"]];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return ((Document *)self.document).className;
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
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", [directoryURL absoluteString], ((Document *)self.document).className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", [directoryURL absoluteString], ((Document *)self.document).className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];

            [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

#pragma mark - NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [self writeRowsWithIndexes:rowIndexes toPasteboard:pboard];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationMove;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    [self acceptDrop:info row:row];
    return YES;
}

#pragma mark - NSCollectionViewDelegate

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {
    [self writeRowsWithIndexes:indexes toPasteboard:pasteboard];
    return YES;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    return NSDragOperationMove;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {
    [self acceptDrop:draggingInfo row:index];
    return YES;
}

#pragma mark - Private

- (void)writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObject:@"Entity"] owner:nil];
    [pboard setPropertyList:[rowIndexes array] forType:@"Entity"];
}

- (void)acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row {
    NSPasteboard *pboard = [info draggingPasteboard];
    NSIndexSet *indexes = [[pboard propertyListForType:@"Entity"] indexSet];
    NSArray *objects = [((Document *)self.document).entities objectsAtIndexes:indexes];
    [((Document *)self.document).entities removeObjectsAtIndexes:indexes];
    for (Entity *object in objects) {
        if (row > [((Document *)self.document).entities count]) {
            [((Document *)self.document).entities addObject:object];
        } else {
            [((Document *)self.document).entities insertObject:object atIndex:row++];
        }
    }
    ((Document *)self.document).entities = ((Document *)self.document).entities;
}

@end
