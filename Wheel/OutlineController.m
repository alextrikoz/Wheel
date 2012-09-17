//
//  OutlineController.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineController.h"

#import "OutlineDocument.h"

@interface OutlineController ()

@property (strong) NSOutlineView *outlineView;

- (IBAction)add:(id)sender;

@end

@implementation OutlineController

@synthesize outlineView = _outlineView;

- (IBAction)add:(id)sender {
    [(OutlineDocument *)self.document addOutlineEntity];
    [self.outlineView deselectAll:nil];
}

@end
