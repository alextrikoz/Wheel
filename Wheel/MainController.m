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
#import "Generator.h"

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
    Generator *generator = [[Generator alloc] init];
    generator.document = self.document;
    NSString *h_content = generator.h_content;
    NSString *m_content = generator.m_content;
    
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

@end
