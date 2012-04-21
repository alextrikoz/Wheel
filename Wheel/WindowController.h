//
//  WindowController.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController <NSTableViewDataSource>

@property (strong) NSMutableArray *entities;
@property (strong) NSMutableArray *setters;
@property (strong) NSMutableArray *atomicities;
@property (strong) NSMutableArray *writabilities;
@property (strong) NSMutableArray *types;

@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSTextField *classNameTextField;
@property (strong) IBOutlet NSTextField *superClassNameTextField;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)onGenerateClick:(id)sender;

@end
