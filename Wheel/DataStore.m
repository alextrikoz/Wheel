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

@implementation DataStore

@synthesize entities = _entities;
@synthesize setters = _setters;
@synthesize atomicities = _atomicities;
@synthesize writabilities = _writabilities;
@synthesize types = _types;

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
    
    self.types = [NSMutableArray array];
    Type *type = [[Type alloc] init];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSArray *";
    [self.types addObject:type];
    type = [[Type alloc] init];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSDate *";
    [self.types addObject:type];
    type = [[Type alloc] init];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSDictionary *";
    [self.types addObject:type];
    type = [[Type alloc] init];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSNumber *";
    [self.types addObject:type];
    type = [[Type alloc] init];
    type.checked = [NSNumber numberWithBool:NO];
    type.name = @"NSString *";
    [self.types addObject:type];
    self.types = self.types;
    
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
}

@end
