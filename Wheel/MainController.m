//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

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
    self.tableView.delegate = self;
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:@"Entity"]];
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

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSMutableArray *indexesArray = [NSMutableArray array];
    NSUInteger index = [rowIndexes firstIndex];
    while(index != NSNotFound) {
        [indexesArray addObject:[NSNumber numberWithInteger:index]];
        index = [rowIndexes indexGreaterThanIndex:index];
    }
    [pboard declareTypes:[NSArray arrayWithObject:@"Entity"] owner:nil];
    NSData *indexesData = [NSKeyedArchiver archivedDataWithRootObject:indexesArray];
    [pboard setData:indexesData forType:@"Entity"];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationMove;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pboard = [info draggingPasteboard];
    NSData *indexesData = [pboard dataForType:@"Entity"];
    NSArray *indexesArray = [NSKeyedUnarchiver unarchiveObjectWithData:indexesData];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSNumber *index in indexesArray) {
        [indexSet addIndex:[index integerValue]];
    }    
    NSArray *objects = [((Document *)self.document).entities objectsAtIndexes:indexSet];
    [((Document *)self.document).entities removeObjectsAtIndexes:indexSet];
    for (Entity *object in objects) {
        if (row > [((Document *)self.document).entities count]) {
            [((Document *)self.document).entities addObject:object];
        } else {
            [((Document *)self.document).entities insertObject:object atIndex:row];
        }
    }
    ((Document *)self.document).entities = ((Document *)self.document).entities;
    return YES;
}

@end
