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

@synthesize setters = _setters;
@synthesize atomicities = _atomicities;
@synthesize writabilities = _writabilities;

@synthesize types = _types;
- (NSArray *)types {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    return [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
}
- (void)setTypes:(NSArray *)types {}

@synthesize selectedTypes = _selectedTypes;

@synthesize options = _options;
- (NSArray *)options {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Option"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]];
    return [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
}
- (void)setOptions:(NSArray *)types {}

- (id)init {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [super init];
    }
    return sharedInstance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadTypes];
    [self loadSetters];
    [self loadAtomicities];
    [self loadWritabilities];
    [self loadOptions];
}

- (void)loadTypes {
    self.types = self.types;
    if (!self.types.count) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSArray *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSDate *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSDictionary *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSNumber *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSString *";
        
        [appDelegate.managedObjectContext save:nil];
        
        self.types = self.types;
    }
}

- (void)loadSetters {
    self.setters = [NSMutableArray array];
    [self.setters addObject:@"assign"];
    [self.setters addObject:@"copy"];
    [self.setters addObject:@"retain"];
    [self.setters addObject:@"strong"];
    [self.setters addObject:@"unsafe_unretained"];
    [self.setters addObject:@"week"];
    self.setters = self.setters;
}

- (void)loadAtomicities {    
    self.atomicities = [NSMutableArray array];
    [self.atomicities addObject:@"atomic"];
    [self.atomicities addObject:@"nonatomic"];
    self.atomicities = self.atomicities;
}

- (void)loadWritabilities {
    self.writabilities = [NSMutableArray array];
    [self.writabilities addObject:@"readonly"];
    [self.writabilities addObject:@"readwrite"];
    self.writabilities = self.writabilities;
}

- (void)loadOptions {
    self.options = self.options;
    if (!self.options.count) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        Option *option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"- (void)dealloc;";
        option.order = [NSNumber numberWithInt:0];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"- (id)initWithDictionary:(NSDictionary *)dictionary;";
        option.order = [NSNumber numberWithInt:1];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"+ (id)objectWithDictionary:(NSDictionary *)dictionary;";
        option.order = [NSNumber numberWithInt:2];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"+ (NSArray *)objectsWithArray:(NSArray *)array;";
        option.order = [NSNumber numberWithInt:3];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"- (NSDictionary *)dictionaryRepresentation;";
        option.order = [NSNumber numberWithInt:4];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"- (NSString *)description;";
        option.order = [NSNumber numberWithInt:5];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"NSCopying";
        option.order = [NSNumber numberWithInt:6];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:YES];
        option.name = @"NSCoding";
        option.order = [NSNumber numberWithInt:7];
        
        option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:appDelegate.managedObjectContext];
        option.active = [NSNumber numberWithBool:YES];
        option.enabled = [NSNumber numberWithBool:NO];
        option.name = @"ARC";
        option.order = [NSNumber numberWithInt:8];
        
        [appDelegate.managedObjectContext save:nil];
        
        self.options = self.options;
    }
    
    [self.options addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:1] forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [self.options addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:2] forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [self.options addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:8] forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[Option class]]) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        Option *option = [self.options objectAtIndex:0];
        option.active = [NSNumber numberWithBool:!self.isARCEnabled];
        
        option = [self.options objectAtIndex:2];
        option.active = [NSNumber numberWithBool:self.isInitWithDictionaryEnabled];
        
        option = [self.options objectAtIndex:3];
        option.active = [NSNumber numberWithBool:self.isInitWithDictionaryEnabled && self.isObjectWithDictionaryEnabled];
        
        [appDelegate.managedObjectContext save:nil];
        self.options = self.options;
    }
}

- (void)addType {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
    type.name = @"NSObject *";
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.types = self.types;
}

- (void)removeSelectedTypes {    
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSArray *selectedTypes = [self.types objectsAtIndexes:self.selectedTypes];
    for (Type *type in selectedTypes) {
        [appDelegate.managedObjectContext deleteObject:type];
    }
    [appDelegate.managedObjectContext save:nil];
    
    self.types = self.types;
}

- (BOOL)isPropertiesEnabled:(NSArray *)entities {
    return entities.count;
}

- (BOOL)isPrototypesEnabled {
    return self.isInitWithDictionaryEnabled || self.isObjectWithDictionaryEnabled || self.isObjectsWithArrayEnabled || self.isDictionaryRepresentationEnabled;
}

- (BOOL)isDefinesEnabled:(NSArray *)entities {
    return entities.count && (self.isInitWithDictionaryEnabled || self.isDictionaryRepresentationEnabled);
}

- (BOOL)isSynthesizesEnabled:(NSArray *)entities {
    return entities.count;
}

- (BOOL)isDeallocEnabled {
    return [((Option *)[self.options objectAtIndex:0]).enabled boolValue] && !self.isARCEnabled;
}

- (BOOL)isInitWithDictionaryEnabled {
    return [((Option *)[self.options objectAtIndex:1]).enabled boolValue];
}

- (BOOL)isObjectWithDictionaryEnabled {
    return [((Option *)[self.options objectAtIndex:2]).enabled boolValue];
}

- (BOOL)isObjectsWithArrayEnabled {
    return [((Option *)[self.options objectAtIndex:3]).enabled boolValue];
}

- (BOOL)isDictionaryRepresentationEnabled {
    return [((Option *)[self.options objectAtIndex:4]).enabled boolValue];    
}

- (BOOL)isDescriptionEnabled {
    return [((Option *)[self.options objectAtIndex:5]).enabled boolValue];
}

- (BOOL)isCopyingEnabled {
    return [((Option *)[self.options objectAtIndex:6]).enabled boolValue];
}

- (BOOL)isCodingEnabled {
    return [((Option *)[self.options objectAtIndex:7]).enabled boolValue];
}

- (BOOL)isARCEnabled {
    return [((Option *)[self.options objectAtIndex:8]).enabled boolValue];
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

- (NSString *)h_properties:(NSArray *)entities {
    if (![self isPropertiesEnabled:entities]) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity h_propertyStuff]];
    }
    return H_PROPERTIES(stuff);
}

- (NSString *)h_prototypes {
    return self.isPrototypesEnabled ? H_PROTOTYPES(self.h_initWithDictionaryPrototype, self.h_objectWithDictionaryPrototype, self.h_objectsWithArrayPrototype, self.h_dictionaryRepresentationPrototype, self.h_descriptionPrototype) : @"";
}

- (NSString *)h_initWithDictionaryPrototype {
    return self.isInitWithDictionaryEnabled ? H_INITWITHDICTIONARY_PROTOTYPE(self.className) : @"";
}

- (NSString *)h_objectWithDictionaryPrototype {
    return self.isObjectWithDictionaryEnabled ? H_OBJECTWITHDICTIONARY_PROTOTYPE(self.className) : @"";
}

- (NSString *)h_objectsWithArrayPrototype {
    return self.isObjectsWithArrayEnabled ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
}

- (NSString *)h_dictionaryRepresentationPrototype {
    return self.isDictionaryRepresentationEnabled ? M_DICTIONARYREPRESENTATION_PROTOTYPE : @"";
}

- (NSString *)h_descriptionPrototype {
    return self.isDescriptionEnabled ? H_DESCRIPTION_PROTOTYPE : @"";
}

- (NSString *)h_content:(NSArray *)entities className:(NSString *)className superClassName:(NSString *)superClassName {    
    return H_CONTENT(self.h_header, className, superClassName, self.h_protocols, [self h_properties:entities], self.h_prototypes);
}

- (NSString *)m_header {
    return [self headerWithFileType:@"m"];
}

- (NSString *)m_defines:(NSArray *)entities {
    if (![self isDefinesEnabled:entities]) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_defineStuff]];
    }
    return M_DEFINES(stuff);
}

- (NSString *)m_synthesizes:(NSArray *)entities {
    if (![self isSynthesizesEnabled:entities]) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

- (NSString *)m_dealloc:(NSArray *)entities {
    if (!self.isDeallocEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

- (NSString *)m_initWithDictionary:(NSArray *)entities {
    if (!self.isInitWithDictionaryEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithDictionaryStuff]];
    }
    return M_INITWITHDICTIONARY(self.className, stuff);
}

- (NSString *)m_objectWithDictionary {
    return self.isObjectWithDictionaryEnabled ? self.isARCEnabled ? M_OBJECTWITHDICTIONARY_ARC(self.className) : M_OBJECTWITHDICTIONARY_MRR(self.className) : @"";
}

- (NSString *)m_objectsWithArray {
    return self.isObjectsWithArrayEnabled ? M_OBJECTSWITHARRAY : @"";
}

- (NSString *)m_dictionaryRepresentation:(NSArray *)entities {
    if (!self.isDictionaryRepresentationEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_dictionaryRepresentationStuff]];
    }
    return M_DICTIONARYREPRESENTATION(stuff);
}

- (NSString *)m_description:(NSArray *)entities {
    if (!self.isDescriptionEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_descriptionStuff]];
    }
    return M_DESCRIPTION(stuff);
}

- (NSString *)m_copyWithZone:(NSArray *)entities {
    if (!self.isCopyingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(self.className, stuff);
}

- (NSString *)m_initWithCoder:(NSArray *)entities {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithCoderStuff]];
    }
    return M_INITWITHCODER(stuff);
}

- (NSString *)m_encodeWithCoder:(NSArray *)entities {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in entities) {
        stuff = [stuff stringByAppendingString:[entity m_encodeWithCoderStuff]];
    }
    return M_ENCODEWITHCODER(stuff);
}

- (NSString *)m_content:(NSArray *)entities className:(NSString *)className {
    return M_CONTENT(self.m_header, className, [self m_defines:entities], [self m_synthesizes:entities], [self m_dealloc:entities], [self m_initWithDictionary:entities], self.m_objectWithDictionary, self.m_objectsWithArray, [self m_dictionaryRepresentation:entities], [self m_description:entities], [self m_copyWithZone:entities], [self m_initWithCoder:entities], [self m_encodeWithCoder:entities]);
}

@end
