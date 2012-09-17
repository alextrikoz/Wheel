//
//  OutlineDocument.m
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import "OutlineDocument.h"

#import "OutlineEntity.h"
#import "OutlineController.h"

@implementation OutlineDocument

@synthesize outlineEntities = _outlineEntities;

- (NSMutableArray *)defaultOutlineEntities {
    NSMutableArray *entities = [NSMutableArray array];
    
    OutlineEntity *entity = [[OutlineEntity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    [entities addObject:entity];
    
    entity = [[OutlineEntity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [entities addObject:entity];
    
    entity = [[OutlineEntity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    [entities addObject:entity];
    
    entity = [[OutlineEntity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSMutableArray *";
    entity.name = @"items";
    entity.children = [NSMutableArray array];
    
    OutlineEntity *subentity = [[OutlineEntity alloc] init];
    subentity.setter = @"strong";
    subentity.atomicity = @"nonatomic";
    subentity.writability = @"readwrite";
    subentity.type = @"Product *";
    subentity.name = @"items";
    subentity.children = [NSMutableArray array];
    
    OutlineEntity *subsubentity = [[OutlineEntity alloc] init];
    subsubentity.setter = @"copy";
    subsubentity.atomicity = @"nonatomic";
    subsubentity.writability = @"readwrite";
    subsubentity.type = @"NSString *";
    subsubentity.name = @"name";
    [subentity.children addObject:subsubentity];
    
    subsubentity = [[OutlineEntity alloc] init];
    subsubentity.setter = @"strong";
    subsubentity.atomicity = @"nonatomic";
    subsubentity.writability = @"readwrite";
    subsubentity.type = @"UIImage *";
    subsubentity.name = @"image";
    [subentity.children addObject:subsubentity];
    
    subsubentity = [[OutlineEntity alloc] init];
    subsubentity.setter = @"strong";
    subsubentity.atomicity = @"nonatomic";
    subsubentity.writability = @"readwrite";
    subsubentity.type = @"NSDecimalNumber *";
    subsubentity.name = @"price";
    [subentity.children addObject:subsubentity];
    
    [entity.children addObject:subentity];
    
    [entities addObject:entity];
    
    return entities;
}

- (void)makeWindowControllers {
    OutlineController *windowController = [[OutlineController alloc] initWithWindowNibName:@"OutlineWnd"];
    [self addWindowController:windowController];
    
    if (!self.outlineEntities) {
        self.outlineEntities = self.defaultOutlineEntities;
    }
}

- (NSString *)displayName {
    return @"Outline";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return YES;
}


@end
