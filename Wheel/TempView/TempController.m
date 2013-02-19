//
//  TempController.m
//  Wheel
//
//  Created by Alexander on 19.02.13.
//
//

#import "TempController.h"

#import "Entity.h"
#import "OutlineDocument.h"

@interface TempController ()

@property IBOutlet NSTextView *textView;

- (IBAction)generate:(id)sender;

@end

@implementation TempController

- (IBAction)generate:(id)sender {
    id object = [NSJSONSerialization JSONObjectWithData:[self.textView.textStorage.string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    Entity *entity = [self entityWithObject:object];
    
    OutlineDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"outline" error:nil];
    document.rootNode = [Entity nodeWithDictionary:entity.dictionaryRepresentation];
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

- (Entity *)entityWithObject:(id)object {
    Entity *entity = [Entity new];
    NSDictionary *info = nil;
    if ([object isKindOfClass:[NSArray class]]) {
        info = [object lastObject];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        info = object;
    }
    
    entity.children = [NSMutableArray array];
    
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Entity *child = nil;
        if ([obj isKindOfClass:[NSArray class]] ) {
            child = [self entityWithObject:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = @"NSArray *";
            child.kind = @"collection";
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            child = [self entityWithObject:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = @"NSDictionary *";
            child.kind = @"model";
        } else if ([obj isKindOfClass:[NSString class]]) {
            child = [Entity new];
            child.setter = @"copy";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = @"NSString *";
            child.kind = @"object";
        }
        child.name = key;
        [entity.children addObject:child];
    }];
    
    return entity;
}

@end
