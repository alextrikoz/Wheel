//
//  JSONDocument.m
//  Wheel
//
//  Created by Alexander on 10.02.13.
//
//

#import "JSONDocument.h"

#import "JSONController.h"

@implementation JSONDocument

- (void)makeWindowControllers {
    [super makeWindowControllers];
    
    JSONController *windowController = [[JSONController alloc] initWithWindowNibName:@"JSONController"];
    [self addWindowController:windowController];
    
    if (!self.JSONString) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultJSON" ofType:@"json"];
        self.JSONString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([self.displayName isEqualToString:@"Untitled"]) {
        self.displayName = @"JSON";
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [self.JSONString dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    self.JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return YES;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    if ([savePanel.nameFieldStringValue isEqualToString:@"Untitled"]) {
        [savePanel setNameFieldStringValue:@"JSON"];
    }
    
    return [super prepareSavePanel:savePanel];
}

@end
