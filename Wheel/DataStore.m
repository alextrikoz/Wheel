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

@synthesize className = _className;
@synthesize superClassName = _superClassName;

@synthesize setters = _setters;
@synthesize atomicities = _atomicities;
@synthesize writabilities = _writabilities;
@synthesize entities = _entities;
@synthesize selectedEntities = _selectedEntities;
@synthesize types = _types;
@synthesize selectedTypes = _selectedTypes;
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
    
    self.className = @"MyClass";
    self.superClassName = @"NSObject";
    
    self.entities = [NSMutableArray array];
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    [self.entities addObject:entity];
    entity = [[Entity alloc] init];
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

- (void)addEntity {
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    self.entities = self.entities;
}

- (void)removeSelectedEntities {
    [self.entities removeObjectsAtIndexes:self.selectedEntities];
    self.entities = self.entities;
}

- (void)addType {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSObject *";
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
}

- (void)removeSelectedTypes {    
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSArray *selectedTypes = [self.types objectsAtIndexes:self.selectedTypes];
    for (Type *type in selectedTypes) {
        [appDelegate.managedObjectContext deleteObject:type];
    }
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.types = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
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

- (NSString *)headerWithFileType:(NSString *)fileType {
    id defaultValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", self.className, fileType];
    NSString *myProjectName = [defaultValues valueForKey:@"MyProjectName"];
    NSString *myName = [defaultValues valueForKey:@"MyName"];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *createdDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *copyrightDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *myCompanyName = [defaultValues valueForKey:@"MyCompanyName"];
    
    return HEADER(fileName, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
}

- (NSString *)h_header {
    return [self headerWithFileType:@"h"];
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
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity h_propertyStuff]];
    }
    return H_PROPERTIES(stuff);
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

- (NSString *)h_content {    
    return H_CONTENT(self.h_header, self.className, self.superClassName, self.h_protocols, self.h_properties, self.h_prototypes);
}

- (NSString *)m_header {
    return [self headerWithFileType:@"m"];
}

- (NSString *)m_synthesizes {
    if (!self.isPropertiesEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

- (NSString *)m_dealloc {
    if (!self.isDeallocEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

- (NSString *)m_initWithDictionary {
    if (!self.isInitWithDictionaryEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithDictionaryStuff]];
    }
    return M_INITWITHDICTIONARY(stuff);
}

- (NSString *)m_objectWithDictionary {
    return self.isObjectWithDictionaryEnabled ? M_OBJECTWITHDICTIONARY : @"";
}

- (NSString *)m_objectsWithArrayEnabled {
    return self.isObjectsWithArrayEnabled ? M_OBJECTSWITHARRAY : @"";
}

- (NSString *)m_copyWithZone {
    if (!self.isCopyingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(self.className, stuff);
}

- (NSString *)m_initWithCoder {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithCoderStuff]];
    }
    return M_INITWITHCODER(stuff);
}

- (NSString *)m_encodeWithCoder {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.entities) {
        stuff = [stuff stringByAppendingString:[entity m_encodeWithCoderStuff]];
    }
    return M_ENCODEWITHCODER(stuff);
}

- (NSString *)m_content {
    return M_CONTENT(self.m_header, self.className, self.m_synthesizes, self.m_dealloc, self.m_initWithDictionary, self.m_objectWithDictionary, self.m_objectsWithArrayEnabled, self.m_copyWithZone, self.m_initWithCoder, self.m_encodeWithCoder);
}

@end
