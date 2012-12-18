//
//  OutlineController.h
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import <Cocoa/Cocoa.h>

@interface OutlineController : NSWindowController <NSOutlineViewDataSource>

@property (strong) IBOutlet NSOutlineView *outlineView;

- (IBAction)addObject:(id)sender;
- (IBAction)addModel:(id)sender;
- (IBAction)addCollection:(id)sender;
- (IBAction)remove:(id)sender;

@property (strong) NSArray *sourceNodes;

@end
