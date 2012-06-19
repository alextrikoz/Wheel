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

@property (strong) Document *document;

@property (strong) IBOutlet NSTableView *tableView;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)generate:(id)sender;

@end
