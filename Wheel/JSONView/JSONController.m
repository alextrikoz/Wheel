//
//  JSONController.m
//  Wheel
//
//  Created by Alexander on 10.02.13.
//
//

#import "JSONController.h"

#import "Entity.h"
#import "OutlineDocument.h"

@interface JSONController ()

@property IBOutlet NSTextView *textView;

- (IBAction)generate:(id)sender;

@end

@implementation JSONController

- (IBAction)generate:(id)sender {
    NSError *error = nil;
    NSString *string = self.textView.textStorage.string;
    string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    id object = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return;
    }
    
    [OutlineDocument showWithEntity:[Entity entityWithCollection:object]];
}

@end
