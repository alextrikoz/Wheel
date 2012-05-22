//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

#import <Carbon/Carbon.h>

#import "Config.h"

#import "Option.h"
#import "Entity.h"
#import "DataStore.h"

@implementation MainController

@synthesize dataStore = _dataStore;

@synthesize tableView = _tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView deselectAll:nil];   
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)add:(id)sender {
    [self.dataStore addEntity];
    [self.tableView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [self.dataStore removeSelectedEntities];
    [self.tableView deselectAll:nil];
}

- (IBAction)generate:(id)sender {    
    NSString *h_content = self.dataStore.h_content;
    NSString *m_content = self.dataStore.m_content;
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"Select";
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", [directoryURL absoluteString], self.dataStore.className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", [directoryURL absoluteString], self.dataStore.className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];            

            [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
