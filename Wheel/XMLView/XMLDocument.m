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
    
    if (!self.XMLString) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultXML" ofType:@"xml"];
        self.XMLString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([self.displayName isEqualToString:@"Untitled"]) {
        self.displayName = @"XML";
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    self.XMLString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [self.XMLString dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    if ([savePanel.nameFieldStringValue isEqualToString:@"Untitled"]) {
        [savePanel setNameFieldStringValue:@"XML"];
    }    
    return [super prepareSavePanel:savePanel];
}

@end
