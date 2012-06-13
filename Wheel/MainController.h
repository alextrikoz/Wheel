//
//  WindowController.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataStore;

@interface MainController : NSWindowController <NSTableViewDataSource>

@property (strong) IBOutlet DataStore *dataStore;

@property (strong) IBOutlet NSTableView *tableView;

@property (strong) NSMutableArray *entities;
@property (strong) NSIndexSet *selectedEntities;
- (void)loadEntities;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;

@end
