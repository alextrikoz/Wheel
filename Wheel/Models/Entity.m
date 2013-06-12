//
//  PersonModel.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

#import "NSString+JSON.h"
#import "NSString+Type.h"
#import "ManagedUnit.h"
#import "DataStore.h"

#define SETTER_KEY @"setter"
#define ATOMICITY_KEY @"atomicity"
#define WRITABILITY_KEY @"writability"
#define TYPE_KEY @"type"
#define NAME_KEY @"name"
#define KEY_KEY @"key"
#define KIND_KEY @"kind"
#define SUPERCLASSNAME_KEY @"superClassName"
#define CHILDREN_KEY @"children"

#define COMMON_OBJECT_FORMAT @"    self.%@ = [dictionary objectForKey:%@_KEY];\n"
#define MODERN_OBJECT_FORMAT @"    self.%@ = [dictionary[%@_KEY] mutableCopy];\n"
#define COMMON_MUTABLE_OBJECT_FORMAT @"    self.%@ = [[dictionary objectForKey:%@_KEY] mutableCopy];\n"
#define MODERN_MUTABLE_OBJECT_FORMAT @"    self.%@ = dictionary[%@_KEY];\n"
#define MODERN_MODEL_FORMAT @"    self.%@ = [%@ objectWithDictionary:dictionary[%@_KEY]];\n"
#define COMMON_MODEL_FORMAT @"    self.%@ = [%@ objectWithDictionary:[dictionary objectForKey:%@_KEY]];\n"
#define MODERN_COLLECTION_FORMAT @"    self.%@ = [%@ objectsWithArray:dictionary[%@_KEY]];\n"
#define COMMON_COLLECTION_FORMAT @"    self.%@ = [%@ objectsWithArray:[dictionary objectForKey:%@_KEY]];\n"
#define MODERN_URL_FORMAT @"    self.%@ = [NSURL URLWithString:dictionary[%@_KEY]];\n"
#define COMMON_URL_FORMAT @"    self.%@ = [NSURL URLWithString:[dictionary objectForKey:%@_KEY]];\n"

@implementation Entity

- (id)init {
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.setter = @"strong";
        self.atomicity = @"nonatomic";
        self.writability = @"readwrite";
        self.type = @"MyClass *";
        self.name = @"myClass";
        self.key = @"myClass";
        self.kind = @"model";
        self.superClassName = @"NSObject";
        self.children = [NSMutableArray array];
    }
    return self;
}

- (NSString *)className {
    NSString *className = [self.type stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [className stringByReplacingOccurrencesOfString:@"*" withString:@""];
}

- (void)setClassName:(NSString *)className {
    self.type = [className stringByAppendingString:@" *"];
}

#pragma mark - Gentration

- (NSString *)h_iVarStuff {
    NSString *type = [self.kind isEqualToString:@"collection"] ? @"NSMutableArray *" : self.type;
    if ([type rangeOfString:@"*"].location == NSNotFound) {
        type = [type stringByAppendingString:@" "];
    }
    return [NSString stringWithFormat:@"    %@_%@;\n", type, self.name];
}

- (NSString *)h_propertyStuff {
    NSString *atomicity = [self.atomicity isEqualToString:@"nonatomic"] ? @", nonatomic" : @"";
    NSString *writability = [self.writability isEqualToString:@"readonly"] ? @", readonly" : @"";
    
    NSString *type = [self.kind isEqualToString:@"collection"] ? @"NSMutableArray *" : self.type;
    if ([type rangeOfString:@"*"].location == NSNotFound) {
        type = [type stringByAppendingString:@" "];
    }
    return [NSString stringWithFormat:@"@property (%@%@%@) %@%@;\n", self.setter, atomicity, writability, type, self.name];
}

- (NSString *)h_importStuff {
    return [self.kind isEqualToString:@"model"] ? [NSString stringWithFormat:@"@class %@;\n", self.className] : @"";
}

- (NSString *)m_importStuff {
    return ![self.kind isEqualToString:@"object"] ? [NSString stringWithFormat:@"#import \"%@.h\"\n", self.className] : @"";
}

- (NSString *)m_defineStuff {
    return [NSString stringWithFormat:@"#define %@_KEY @\"%@\"\n", self.name.uppercaseString, self.key];
}

- (NSString *)m_synthesizeStuff {
    return [NSString stringWithFormat:@"@synthesize %@ = _%@;\n", self.name, self.name];
}

- (NSString *)m_deallocStuff {
    return [NSString stringWithFormat:@"    [_%@ release];\n", self.name];
}

- (NSString *)m_setAttributesWithDictionaryStuff {
    BOOL isModern = DataStore.sharedDataStore.modernSyntaxUnit.available;
    if ([self.kind isEqualToString:@"object"]) {
        NSString *format = (isModern) ? (self.type.isMutable ? MODERN_MUTABLE_OBJECT_FORMAT : MODERN_OBJECT_FORMAT) : (self.type.isMutable ? COMMON_MUTABLE_OBJECT_FORMAT : COMMON_OBJECT_FORMAT);
        if ([self.type isEqualToString:@"NSDate *"]) {
            if (DataStore.sharedDataStore.ARCUnit.available) {
                format = [NSString stringWithFormat:@"    NSDateFormatter *%@Formatter = [NSDateFormatter new];\n", self.name];
            } else {
                format = [NSString stringWithFormat:@"    NSDateFormatter *%@Formatter = [[NSDateFormatter new] autorelease];\n", self.name];
            }
            format = [format stringByAppendingFormat:@"    %@Formatter.dateFormat = @\"yyyy-MM-dd'T'HH:mm:ss\";\n", self.name];
            format = [format stringByAppendingFormat:@"    self.%@ = ", self.name];
            if (isModern) {
                format = [format stringByAppendingString:@"[%@Formatter dateFromString:dictionary[%@_KEY]];\n"];
            } else {
                format = [format stringByAppendingString:@"[%@Formatter dateFromString:[dictionary objectForKey:%@_KEY]];\n"];
            }
        } else if ([self.type isEqualToString:@"NSURL *"]) {
            format = (isModern) ? MODERN_URL_FORMAT : COMMON_URL_FORMAT;
        }
        return [NSString stringWithFormat:format, self.name, self.name.uppercaseString];
    } else if ([self.kind isEqualToString:@"model"]) {
        NSString *format = (isModern) ? MODERN_MODEL_FORMAT : COMMON_MODEL_FORMAT;
        return [NSString stringWithFormat:format, self.name, self.className, self.name.uppercaseString];
    } else {
        NSString *format = (isModern) ? MODERN_COLLECTION_FORMAT : COMMON_COLLECTION_FORMAT;
        return [NSString stringWithFormat:format, self.name, self.className, self.name.uppercaseString];
    }
}

- (NSString *)m_dictionaryRepresentationStuff {
    if ([self.kind isEqualToString:@"object"]) {
        return [NSString stringWithFormat:@"    [dictionary setValue:self.%@ forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
    } else if ([self.kind isEqualToString:@"model"]) {
        return [NSString stringWithFormat:@"    [dictionary setValue:self.%@.dictionaryRepresentation forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
    } else {
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"    NSMutableArray *array = [NSMutableArray array];\n"];
        [string appendFormat:@"    for (%@ *object in self.%@) {\n", self.className, self.name];
        if (DataStore.sharedDataStore.modernSyntaxUnit.available) {
            [string appendFormat:@"        array[array.count] = object.dictionaryRepresentation;\n"];
        } else {
            [string appendFormat:@"        [array addObject:object.dictionaryRepresentation];\n"];
        }
        [string appendFormat:@"    }\n"];
        [string appendFormat:@"    [dictionary setValue:array forKey:%@_KEY];\n", self.name.uppercaseString];
        return string;
    }
}

- (NSString *)m_descriptionStuff {
    return [NSString stringWithFormat:@"    description = [description stringByAppendingFormat:@\"    self.%@ = %%@\\n\", self.%@];\n", self.name, self.name];
}

- (NSString *)m_copyWithZoneStuff {
    return [NSString stringWithFormat:@"    object.%@ = self.%@;\n", self.name, self.name];
}

- (NSString *)m_initWithCoderStuff {
    return [NSString stringWithFormat:@"        self.%@ = [decoder decodeObjectForKey:%@_KEY];\n", self.name, self.name.uppercaseString];
}

- (NSString *)m_encodeWithCoderStuff {
    return [NSString stringWithFormat:@"    [coder encodeObject:self.%@ forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
}

#pragma mark - Convertation

+ (Entity *)objectWithDictionary:(NSDictionary *)dictionary {
    Entity *object = [Entity new];
    if (dictionary[SETTER_KEY]) {
        object.setter = dictionary[SETTER_KEY];
    }
    if (dictionary[ATOMICITY_KEY]) {
        object.atomicity = dictionary[ATOMICITY_KEY];
    }
    if (dictionary[WRITABILITY_KEY]) {
        object.writability = dictionary[WRITABILITY_KEY];
    }
    if (dictionary[TYPE_KEY]) {
        object.type = dictionary[TYPE_KEY];
    }
    if (dictionary[NAME_KEY]) {
        object.name = dictionary[NAME_KEY];
    }
    if (dictionary[KEY_KEY]) {
        object.key = dictionary[KEY_KEY];
    }
    if (dictionary[KIND_KEY]) {
        object.kind = dictionary[KIND_KEY];
    }
    if (dictionary[SUPERCLASSNAME_KEY]) {
        object.superClassName = dictionary[SUPERCLASSNAME_KEY];
    }
    if (dictionary[CHILDREN_KEY]) {
        object.children = [self objectsWithArray:dictionary[CHILDREN_KEY]];
    }
    return object;
}

+ (NSMutableArray *)objectsWithArray:(NSArray *)array {
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [objects addObject:[Entity objectWithDictionary:dictionary]];
    }
    return objects;
}

- (NSMutableDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.setter forKey:SETTER_KEY];
    [dictionary setValue:self.atomicity forKey:ATOMICITY_KEY];
    [dictionary setValue:self.writability forKey:WRITABILITY_KEY];
    [dictionary setValue:self.type forKey:TYPE_KEY];
    [dictionary setValue:self.name forKey:NAME_KEY];
    [dictionary setValue:self.key forKey:KEY_KEY];
    [dictionary setValue:self.kind forKey:KIND_KEY];
    [dictionary setValue:self.superClassName forKey:SUPERCLASSNAME_KEY];
    NSMutableArray *childrenRepresentation = [NSMutableArray array];
    for (Entity *entity in self.children) {
        [childrenRepresentation addObject:entity.dictionaryRepresentation];
    }
    [dictionary setValue:childrenRepresentation forKey:CHILDREN_KEY];
    return dictionary;
}

+ (NSTreeNode *)nodeWithDictionary:(NSDictionary *)dictionary {
    Entity *entity = [Entity objectWithDictionary:dictionary];
    NSArray *children = dictionary[CHILDREN_KEY];
    NSTreeNode *node = [NSTreeNode treeNodeWithRepresentedObject:entity];
    for (NSDictionary *child in children) {
        [node.mutableChildNodes addObject:[self nodeWithDictionary:child]];
    }
    return node;
}

+ (NSDictionary *)dictionaryWithNode:(NSTreeNode *)node {
    Entity *entity = node.representedObject;
    NSMutableDictionary *dictionary = [entity dictionaryRepresentation];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTreeNode *childNode in node.childNodes) {
        [array addObject:[self dictionaryWithNode:childNode]];
    }
    dictionary[CHILDREN_KEY] = array;
    return dictionary;
}

#pragma mark - Stubs

+ (NSMutableArray *)plainStub {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultTable" ofType:@"plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    return [Entity objectsWithArray:array];
}

+ (NSTreeNode *)outlineStub {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultOutline" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return [self nodeWithDictionary:dictionary];
}

+ (Entity *)objectStub {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultEntity" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return [Entity objectWithDictionary:dictionary];
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[@"MyPasteboardType.wheel"];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.setter forKey:SETTER_KEY];
    [coder encodeObject:self.atomicity forKey:ATOMICITY_KEY];
    [coder encodeObject:self.writability forKey:WRITABILITY_KEY];
    [coder encodeObject:self.type forKey:TYPE_KEY];
    [coder encodeObject:self.name forKey:NAME_KEY];
    [coder encodeObject:self.key forKey:KEY_KEY];
    [coder encodeObject:self.kind forKey:KIND_KEY];
    [coder encodeObject:self.superClassName forKey:SUPERCLASSNAME_KEY];
    [coder encodeObject:self.children forKey:CHILDREN_KEY];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.setter = [decoder decodeObjectForKey:SETTER_KEY];
        self.atomicity = [decoder decodeObjectForKey:ATOMICITY_KEY];
        self.writability = [decoder decodeObjectForKey:WRITABILITY_KEY];
        self.type = [decoder decodeObjectForKey:TYPE_KEY];
        self.name = [decoder decodeObjectForKey:NAME_KEY];
        self.key = [decoder decodeObjectForKey:KEY_KEY];
        self.kind = [decoder decodeObjectForKey:KIND_KEY];
        self.superClassName = [decoder decodeObjectForKey:SUPERCLASSNAME_KEY];
        self.children = [decoder decodeObjectForKey:CHILDREN_KEY];
    }
    return self;
}

#pragma mark - Parser

+ (Entity *)entityWithInfo:(id)object {
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
            child = [self entityWithInfo:obj];
            if (![child.kind isEqualToString:@"object"]) {
                child.setter = @"strong";
                child.atomicity = @"nonatomic";
                child.writability = @"readwrite";
                child.type = key.typeName;                
                child.kind = @"collection";
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            child = [self entityWithInfo:obj];
            child.setter = @"strong";
            child.atomicity = @"nonatomic";
            child.writability = @"readwrite";
            child.type = key.typeName;            
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
        } else if ([obj isKindOfClass:[NSNull class]]) {
            child = [Entity new];
            child.type = @"NSNull *";
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
