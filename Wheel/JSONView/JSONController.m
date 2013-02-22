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
    
    Entity *entity = [Entity entityWithCollection:object];
    
    OutlineDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"outline" error:nil];
    document.rootNode = [Entity nodeWithDictionary:entity.dictionaryRepresentation];
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

@end
