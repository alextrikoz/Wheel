//
//  XMLController.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLController.h"

#import "XMLParser.h"
#import "Entity.h"
#import "OutlineDocument.h"

@interface XMLController ()

@property IBOutlet NSTextView *textView;

- (IBAction)generate:(id)sender;

@end

@implementation XMLController

- (IBAction)generate:(id)sender {
    NSError *error = nil;
    NSString *string = self.textView.textStorage.string;
    id object = [XMLParser dictionaryWithData:[string dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return;
    }
    
    [OutlineDocument showWithEntity:[Entity entityWithInfo:object]];    
}

@end
