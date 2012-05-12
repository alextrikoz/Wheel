//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

#import "Config.h"

#import "Option.h"
#import "Entity.h"
#import "DataStore.h"

@implementation MainController

@synthesize dataStore = _dataStore;

@synthesize tableView = _tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView deselectRow:self.tableView.selectedRow];    
}

- (IBAction)add:(id)sender {    
    Entity *entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.dataStore.entities addObject:entity];
    
    self.dataStore.entities = self.dataStore.entities;
    
    [self.tableView deselectRow:self.tableView.selectedRow];
}

- (IBAction)remove:(id)sender {    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.dataStore.entities.count];
    for (Entity *entity in self.dataStore.entities) {
        if (!entity.checked.boolValue) {
            [temp addObject:entity];
        }
    }
    self.dataStore.entities = temp;
    [self.tableView deselectRow:self.tableView.selectedRow];
}

- (IBAction)generate:(id)sender {    
    NSString *h_content = self.dataStore.h_content;
    NSString *m_content = self.dataStore.m_content;
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"Select"];
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
