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
        
        Option *initWithDictionaryOption = [self.options objectAtIndex:1];
        Option *objectWithDictionaryOption = [self.options objectAtIndex:2];
        Option *ARCOption = [self.options objectAtIndex:8];
        
        Option *deallocOption = [self.options objectAtIndex:0];
        deallocOption.active = [NSNumber numberWithBool:![ARCOption.enabled boolValue]];
        
        objectWithDictionaryOption.active = initWithDictionaryOption.enabled;
        
        Option *objectsWithArrayOption = [self.options objectAtIndex:3];
        objectsWithArrayOption.active = objectWithDictionaryOption.active;
        
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

@end
