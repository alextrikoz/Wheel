//
//  TempController.m
//  Wheel
//
//  Created by Alexander on 19.02.13.
//
//

#import "TempController.h"

#import "Type.h"
#import "Entity.h"
#import "OutlineDocument.h"
#import "DataStore.h"
#import "AppDelegate.h"

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
    
    if ([info isKindOfClass:[NSNull class]]) {
        return entity;
    }
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        Entity *child = nil;
        if ([obj isKindOfClass:[NSArray class]] ) {
            child = [self entityWithObject:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            
            NSString *typeName = [key.capitalizedString stringByAppendingString:@" *"];
            child.type = typeName;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
            request.predicate = [NSPredicate predicateWithFormat:@"self.name like %@", typeName];
            if ([((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:request error:nil].count == 0) {
                Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext];
                type.name = typeName;
                [((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext save:nil];
            }
            
            child.kind = @"collection";
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            child = [self entityWithObject:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            
            NSString *typeName = [key.capitalizedString stringByAppendingString:@" *"];
            child.type = typeName;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
            request.predicate = [NSPredicate predicateWithFormat:@"self.name like %@", typeName];
            if ([((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:request error:nil].count == 0) {
                Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:((AppDelegate *)[NSApplication sharedApplication].delegate).managedObjectContext];
                type.name = typeName;
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
        child.name = key;
        [entity.children addObject:child];
    }];
    
    return entity;
}

@end
