//
//  WindowController.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController

@property (strong) NSMutableArray *entities;
@property (strong) NSMutableArray *types;

@property (strong) IBOutlet NSTextField *classNameTextField;
@property (strong) IBOutlet NSTextField *superClassNameTextField;

- (IBAction)add:(id)sender;
- (IBAction)onGenerateClick:(id)sender;

@end
