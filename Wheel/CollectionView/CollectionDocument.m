//
//  CollectionDocument.m
//  Wheel
//
//  Created by Alexander on 13.02.13.
//
//

#import "CollectionDocument.h"

#import "CollectionController.h"

@implementation CollectionDocument

- (void)makeWindowControllers {
    CollectionController *windowController = [[CollectionController alloc] initWithWindowNibName:@"CollectionController"];
    [self addWindowController:windowController];
    
    if ([self.displayName isEqualToString:@"Untitled"]) {
        self.displayName = @"Window";
    }
}

- (IBAction)saveDocument:(id)sender {
    
}

@end
