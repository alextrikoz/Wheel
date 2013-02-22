//
//  XMLDocument.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLDocument.h"
#import "XMLController.h"

@implementation XMLDocument

- (void)makeWindowControllers {
    [super makeWindowControllers];
    
    XMLController *windowController = [[XMLController alloc] initWithWindowNibName:@"XMLController"];
    [self addWindowController:windowController];
    
    if ([self.displayName isEqualToString:@"Untitled"]) {
        self.displayName = @"XML";
    }
}

@end
