//
//  JSONController.m
//  Wheel
//
//  Created by Alexander on 10.02.13.
//
//

#import "JSONController.h"

#import "Type.h"
#import "Entity.h"
#import "JSONDocument.h"
#import "OutlineDocument.h"
#import "DataStore.h"
#import "AppDelegate.h"
#import "NSString+JSON.h"

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
    
    Entity *entity = [JSONController entityWithCollection:object];
    
    OutlineDocument *document = [[NSDocumentController sharedDocumentController] makeUntitledDocumentOfType:@"outline" error:nil];
    document.rootNode = [Entity nodeWithDictionary:entity.dictionaryRepresentation];
    [[NSDocumentController sharedDocumentController] addDocument:document];
    [document makeWindowControllers];
    [document showWindows];
}

+ (Entity *)entityWithCollection:(id)object {
    Entity *entity = [Entity new];
    
    entity.children = [NSMutableArray array];
    
    NSDictionary *info = nil;
    if ([object isKindOfClass:[NSArray class]]) {
        info = [object lastObject];
        if (![info isKindOfClass:[NSDictionary class]]) {
            entity.setter = @"strong";
            entity.atomicity = @"nonatomic";
            entity.writability = @"readwrite";
            entity.type = @"NSArray *";
            entity.kind = @"object";
            return entity;
        }        
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        info = object;
    }
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        Entity *child = nil;
        if ([obj isKindOfClass:[NSArray class]] ) {
            child = [self entityWithCollection:obj];
            
            if ([child.kind isEqualToString:@"object"]) {
                
            } else {
                child.setter = @"strong";
                child.atomicity = @"nonatomic";
                child.writability = @"readwrite";
                child.type = key.typeName;
                
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
                request.predicate = [NSPredicate predicateWithFormat:@"self.name like %@", key.typeName];
                if ([((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:request error:nil].count == 0) {
                    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext];
                    type.name = key.typeName;
                    [((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext save:nil];
                }
                
                child.kind = @"collection";
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            child = [JSONController entityWithCollection:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = key.typeName;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
            request.predicate = [NSPredicate predicateWithFormat:@"self.name like %@", child.type];
            if ([((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:request error:nil].count == 0) {
                Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext];
                type.name = child.type;
                [((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext save:nil];
            }
            
            child.kind = @"model";
        } else if ([obj isKindOfClass:[NSString class]]) {
            child = [Entity new];
            child.setter = @"copy";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = @"NSString *";
            child.kind = @"object";
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            child = [Entity new];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = @"NSNumber *";
            child.kind = @"object";
        } else {
            child = [Entity new];
        }
        child.name = key.varName;
        child.key = key;
        [entity.children addObject:child];
    }];
    
    return entity;
}

@end
