//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import "OutlineDocument.h"
#import <Carbon/Carbon.h>

@interface OutlineController ()

@property (strong) IBOutlet NSOutlineView *outlineView;

- (IBAction)addObject:(id)sender;
- (IBAction)addModel:(id)sender;
- (IBAction)addCollection:(id)sender;
- (IBAction)remove:(id)sender;

@end

@implementation OutlineController

@synthesize outlineView = _outlineView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.outlineView deselectAll:nil];
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)addObject:(id)sender {
    [(OutlineDocument *)self.document addObject];
    [self.outlineView deselectAll:nil];
}

- (IBAction)addModel:(id)sender {
    [(OutlineDocument *)self.document addModel];
    [self.outlineView deselectAll:nil];
}

- (IBAction)addCollection:(id)sender {
    [(OutlineDocument *)self.document addCollection];
    [self.outlineView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [(OutlineDocument *)self.document removeSelectedEntities];
    [self.outlineView deselectAll:nil];
}

@end
