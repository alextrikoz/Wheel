//
//  PersonModel.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity

#pragma mark - setter

@synthesize setter = _setter;

- (void)setSetter:(NSString *)setter {
    if (![_setter isEqual:setter]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setSetter:_setter];
        _setter = setter;
    }
}

- (NSString *)setter {
    return _setter;
}

#pragma mark - atomicity

@synthesize atomicity = _atomicity;

- (void)setAtomicity:(NSString *)atomicity {
    if (![_atomicity isEqual:atomicity]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setAtomicity:_atomicity];
        _atomicity = atomicity;
    }
}

- (NSString *)atomicity {
    return _atomicity;
}

#pragma mark - writability

@synthesize writability = _writability;

- (void)setWritability:(NSString *)writability {
    if (![_writability isEqual:writability]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setWritability:_writability];
        _writability = writability;
    }
}

- (NSString *)writability {
    return _writability;
}

#pragma mark - type

@synthesize type = _type;

- (void)setType:(NSString *)type {
    if (![_type isEqual:type]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setType:_type];
        _type = type;
    }
}

- (NSString *)type {
    return _type;
}

#pragma mark - name

@synthesize name = _name;

- (void)setName:(NSString *)name {
    if (![_name isEqual:name]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setName:_name];
        _name = name;
    }
}

- (NSString *)name {
    return _name;
}

#pragma mark - kind

@synthesize kind = _kind;

- (void)setKind:(NSString *)kind {
    if (![_kind isEqual:kind]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setKind:kind];
        _kind = kind;
    }
}

- (NSString *)kind {
    return _kind;
}

#pragma mark - key

@synthesize key = _key;

- (void)setKey:(NSString *)key {
    if (![_key isEqual:key]) {
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setKey:key];
        _key = key;
    }
}

- (NSString *)key {
    return _key;
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeString];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - gentrator

- (NSString *)className {
    NSString *className = [self.type stringByReplacingOccurrencesOfString:@"*" withString:@""];
    return [className stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)h_iVarStuff {
    NSString *type = [self.kind isEqualToString:@"collection"] ? @"NSMutableArray *" : self.type;
    return [NSString stringWithFormat:@"    %@_%@;\n", type, self.name];
}

- (NSString *)h_propertyStuff {
    NSString *atomicity = [self.atomicity isEqualToString:@"nonatomic"] ? @", nonatomic" : @"";
    NSString *writability = [self.writability isEqualToString:@"readonly"] ? @", readonly" : @"";
    
    NSString *type = [self.kind isEqualToString:@"collection"] ? @"NSMutableArray *" : self.type;
    if ([type rangeOfString:@"*"].location == NSNotFound && [type rangeOfString:@" "].location == NSNotFound) {
        type = [type stringByAppendingString:@" "];
    }
    return [NSString stringWithFormat:@"@property (%@%@%@) %@%@;\n", self.setter, atomicity, writability, type, self.name];
}

- (NSString *)h_importStuff {
    if ([self.kind isEqualToString:@"object"]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"@class %@;\n", self.className];
}

- (NSString *)m_importStuff {
    if ([self.kind isEqualToString:@"object"]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"#import \"%@.h\"\n", self.className];
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
    if ([self.kind isEqualToString:@"object"]) {
        return [NSString stringWithFormat:@"    self.%@ = [dictionary objectForKey:%@_KEY];\n", self.name, self.name.uppercaseString];
    } else if ([self.kind isEqualToString:@"model"]) {
        return [NSString stringWithFormat:@"    self.%@ = [%@ objectWithDictionary:[dictionary objectForKey:%@_KEY]];\n", self.name, self.className, self.name.uppercaseString];
    } else {
        return [NSString stringWithFormat:@"    self.%@ = [%@ objectsWithArray:[dictionary objectForKey:%@_KEY]];\n", self.name, self.className, self.name.uppercaseString];
    }
}

- (NSString *)m_dictionaryRepresentationStuff {    
    if ([self.kind isEqualToString:@"object"]) {
        return [NSString stringWithFormat:@"    [dictionary setObject:self.%@ forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
    } else if ([self.kind isEqualToString:@"model"]) {
        return [NSString stringWithFormat:@"    [dictionary setObject:self.%@.dictionaryRepresentation forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
    } else {
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"    NSMutableArray *array = [NSMutableArray array];\n"];
        [string appendFormat:@"    for (%@ *object self.%@) {\n", self.className, self.name];
        [string appendFormat:@"        [array addObject:object.dictionaryRepresentation];\n"];
        [string appendFormat:@"    }\n"];
        [string appendFormat:@"    [dictionary setObject:array forKey:%@_KEY];\n", self.name.uppercaseString];
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

#pragma mark - 

+ (Entity *)objectWithDictionary:(NSDictionary *)dictionary {
    Entity *object = [[Entity alloc] init];
    object.setter = dictionary[@"setter"];
    object.atomicity = dictionary[@"atomicity"];
    object.writability = dictionary[@"writability"];
    object.type = dictionary[@"type"];
    object.name = dictionary[@"name"];
    object.kind = dictionary[@"kind"];
    object.key = dictionary[@"key"];
    object.children = [self objectsWithArray:dictionary[@"children"]];
    return object;
}

+ (NSMutableArray *)objectsWithArray:(NSArray *)array {
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [objects addObject:[Entity objectWithDictionary:dictionary]];
    }
    return objects;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.setter forKey:@"setter"];
    [dictionary setValue:self.atomicity forKey:@"atomicity"];
    [dictionary setValue:self.writability forKey:@"writability"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.kind forKey:@"kind"];
    [dictionary setValue:self.key forKey:@"key"];
    
    NSMutableArray *childrenRepresentation = [NSMutableArray array];
    for (Entity *entity in self.children) {
        [childrenRepresentation addObject:entity.dictionaryRepresentation];
    }
    [dictionary setValue:childrenRepresentation forKey:@"children"];
    
    return dictionary;
}

+ (NSTreeNode *)nodeWithDictionary:(NSDictionary *)dictionary {
    Entity *entity = [Entity objectWithDictionary:dictionary];
    
    NSArray *children = [dictionary objectForKey:@"children"];
    
    NSTreeNode *node = [NSTreeNode treeNodeWithRepresentedObject:entity];
    for (NSDictionary *child in children) {
        [node.mutableChildNodes addObject:[self nodeWithDictionary:child]];
    }
    return node;
}

+ (Entity *)entityWithNode:(NSTreeNode *)node {
    Entity *entity = node.representedObject;
    [entity.children removeAllObjects];
    for (NSTreeNode *childNode in node.childNodes) {
        [entity.children addObject:[self entityWithNode:childNode]];
    }
    return entity;
}

+ (NSMutableArray *)plainStub {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Plain" ofType:@"plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    return [Entity objectsWithArray:array];
}

+ (NSTreeNode *)outlineStub {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Outline" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return [self nodeWithDictionary:dictionary];
}

+ (Entity *)defaultEntity {
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    entity.kind = @"object";
    entity.key = @"items";
    entity.children = [NSMutableArray array];
    return entity;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.setter forKey:@"setter"];
    [coder encodeObject:self.atomicity forKey:@"atomicity"];
    [coder encodeObject:self.writability forKey:@"writability"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.kind forKey:@"kind"];
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.children forKey:@"children"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.setter = [decoder decodeObjectForKey:@"setter"];
        self.atomicity = [decoder decodeObjectForKey:@"atomicity"];
        self.writability = [decoder decodeObjectForKey:@"writability"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.kind = [decoder decodeObjectForKey:@"kind"];
        self.key = [decoder decodeObjectForKey:@"key"];
        self.children = [decoder decodeObjectForKey:@"children"];
    }
    return self;
}

@end
