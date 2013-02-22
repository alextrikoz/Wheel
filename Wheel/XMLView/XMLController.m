//
//  XMLController.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLController.h"

#import "Entity.h"
#import "OutlineDocument.h"
#import "XMLParser.h"

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
    
    Entity *entity = [Entity entityWithCollection:object];
    
    OutlineDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"outline" error:nil];
    document.rootNode = [Entity nodeWithDictionary:entity.dictionaryRepresentation];
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

@end
