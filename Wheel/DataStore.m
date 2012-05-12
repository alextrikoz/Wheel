//
//  DataStore.m
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"

#import "Type.h"
#import "Entity.h"
#import "Option.h"

#import "AppDelegate.h"

#import "Config.h"

@implementation DataStore

@synthesize entities = _entities;
@synthesize setters = _setters;
@synthesize atomicities = _atomicities;
@synthesize writabilities = _writabilities;
@synthesize types = _types;
@synthesize options = _options;

- (id)init {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [super init];
    }
    return sharedInstance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.entities = [NSMutableArray array];
    Entity *entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    self.entities = self.entities;
    
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    if (!self.types.count) {
        Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.checked = [NSNumber numberWithBool:NO];
        type.name = @"NSArray *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.checked = [NSNumber numberWithBool:NO];
        type.name = @"NSDate *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.checked = [NSNumber numberWithBool:NO];
        type.name = @"NSDictionary *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.checked = [NSNumber numberWithBool:NO];
        type.name = @"NSNumber *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.checked = [NSNumber numberWithBool:NO];
        type.name = @"NSString *";
        
        [appDelegate.managedObjectContext save:nil];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
        request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
        self.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    }
    
    self.setters = [NSMutableArray array];
    [self.setters addObject:@"assign"];
    [self.setters addObject:@"copy"];
    [self.setters addObject:@"retain"];
    [self.setters addObject:@"strong"];
    [self.setters addObject:@"unsafe_unretained"];
    [self.setters addObject:@"week"];
    self.setters = self.setters;
    
    self.atomicities = [NSMutableArray array];
    [self.atomicities addObject:@"atomic"];
    [self.atomicities addObject:@"nonatomic"];
    self.atomicities = self.atomicities;
    
    self.writabilities = [NSMutableArray array];
    [self.writabilities addObject:@"readonly"];
    [self.writabilities addObject:@"readwrite"];
    self.writabilities = self.writabilities;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Option"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]];
    self.options = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    if (!self.options.count) {
        Option *option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:0];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"- (void)dealloc;";
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:1];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"- (id)initWithDictionary:(NSDictionary *)dictionary;";
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:2];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"+ (id)objectWithDictionary:(NSDictionary *)dictionary;";
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:3];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"+ (NSArray *)objectsWithArray:(NSArray *)array;";
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:4];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"NSCopying";
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.order = [NSNumber numberWithInt:5];
        option.checked = [NSNumber numberWithBool:YES];
        option.name = @"NSCoding";
        
        [appDelegate.managedObjectContext save:nil];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Option"];
        request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]];
        self.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    }
}

- (BOOL)isPropertiesEnabled {
    return self.entities.count;
}

- (BOOL)isPrototypesEnabled {
    return self.isInitWithDictionaryEnabled || self.isObjectWithDictionaryEnabled || self.isObjectsWithArrayEnabled;
}

- (BOOL)isDeallocEnabled {
    return [((Option *)[self.options objectAtIndex:0]).checked boolValue];
}

- (BOOL)isInitWithDictionaryEnabled {
    return [((Option *)[self.options objectAtIndex:1]).checked boolValue];
}

- (BOOL)isObjectWithDictionaryEnabled {
    return [((Option *)[self.options objectAtIndex:2]).checked boolValue];
}

- (BOOL)isObjectsWithArrayEnabled {
    return [((Option *)[self.options objectAtIndex:3]).checked boolValue];
}

- (BOOL)isCopyingEnabled {
    return [((Option *)[self.options objectAtIndex:4]).checked boolValue];
}

- (BOOL)isCodingEnabled {
    return [((Option *)[self.options objectAtIndex:5]).checked boolValue];
}

- (NSString *)h_protocols {
    if (self.isCopyingEnabled && self.isCodingEnabled) {
        return @"<NSCopying, NSCoding>";
    } else if (self.isCopyingEnabled) {
        return @"<NSCopying>";
    } else if (self.isCodingEnabled) {
        return @"<NSCoding>";
    } else {
        return @"";
    }
}

- (NSString *)h_properties {
    if (!self.isPropertiesEnabled) {
        return @"";
    }
    
    NSString *h_properties = @"";
    for (Entity *entity in self.entities) {
        h_properties = [h_properties stringByAppendingString:[entity propertyFormat]];
    }
    return H_PROPERTIES(h_properties);
}

- (NSString *)h_initWithDictionaryPrototype {
    return self.isInitWithDictionaryEnabled ? H_INITWITHDICTIONARY_PROTOTYPE : @"";
}

- (NSString *)h_objectWithDictionaryPrototype {
    return self.isObjectWithDictionaryEnabled ? H_OBJECTWITHDICTIONARY_PROTOTYPE : @"";
}

- (NSString *)h_objectsWithArrayPrototype {
    return self.isObjectsWithArrayEnabled ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
}

- (NSString *)h_prototypes {
    return self.isPrototypesEnabled ? H_PROTOTYPES(self.h_initWithDictionaryPrototype, self.h_objectWithDictionaryPrototype, self.h_objectsWithArrayPrototype) : @"";
}

- (NSString *)m_synthesizes {
    if (!self.isPropertiesEnabled) {
        return @"";
    }
    
    NSString *m_synthesizes = @"";
    for (Entity *entity in self.entities) {
        m_synthesizes = [m_synthesizes stringByAppendingString:[entity synthesizeFormat]];
    }
    return SYNTHESIZE(m_synthesizes);
}

@end
