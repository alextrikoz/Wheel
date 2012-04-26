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
    
    self.options = [NSMutableArray array];
    Option *option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"- (void)dealloc;";
    [self.options addObject:option];
    option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"- (id)initWithDictionary:(NSDictionary *)dictionary;";
    [self.options addObject:option];
    option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"+ (id)objectWithDictionary:(NSDictionary *)dictionary;";
    [self.options addObject:option];
    option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"+ (id)copyWithZone:(NSZone *)zone;";
    [self.options addObject:option];
    option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"- (void)encodeWithCoder:(NSCoder *)coder;";
    [self.options addObject:option];
    option = [[Option alloc] init];
    option.checked = [NSNumber numberWithBool:YES];
    option.name = @"- (id)initWithCoder:(NSCoder *)decoder;";
    [self.options addObject:option];
    self.options = self.options;
}

@end
