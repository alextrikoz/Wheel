//
//  WindowController.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Document;

@interface MainController : NSWindowController <NSTableViewDataSource>

- (Document *)document;

@property (strong) IBOutlet NSTableView *tableView;

@property (strong) IBOutlet NSIndexSet *sourceIndexes;
@property (strong) IBOutlet NSArray *draggedItems;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;

@end
