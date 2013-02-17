//
//  PersonModel.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

#define SYNTHESIZE(setter, getter) \
@synthesize getter = _##getter; \
 \
- (void)setter:(NSString *)getter { \
    if (![_##getter isEqual:getter]) { \
        [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setter:_##getter]; \
        _##getter = getter; \
    } \
} \
 \
- (NSString *)getter { \
    return _##getter; \
}

@implementation Entity

SYNTHESIZE(setSetter, setter);
SYNTHESIZE(setAtomicity, atomicity);
SYNTHESIZE(setWritability, writability);
SYNTHESIZE(setType, type);
SYNTHESIZE(setName, name);
SYNTHESIZE(setKind, kind);
SYNTHESIZE(setKey,key);

#pragma mark - className

- (NSString *)className {
    NSString *className = [self.type stringByReplacingOccurrencesOfString:@"*" withString:@""];
    return [className stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - Gentration

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
    return [self.kind isEqualToString:@"collection"] ? [NSString stringWithFormat:@"@class %@;\n", self.className] : @"";
}

- (NSString *)m_importStuff {
    return [self.kind isEqualToString:@"object"] ? @"" : [NSString stringWithFormat:@"#import \"%@.h\"\n", self.className];
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

#pragma mark - Convertation

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

- (NSMutableDictionary *)dictionaryRepresentation {
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

+ (NSDictionary *)dictionaryWithNode:(NSTreeNode *)node {
    Entity *entity = node.representedObject;
    NSMutableDictionary *dictionary = [entity dictionaryRepresentation];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTreeNode *childNode in node.childNodes) {
        [array addObject:[childNode.representedObject dictionaryRepresentation]];
    }
    [dictionary setObject:array forKey:@"children"];
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
    return @[NSPasteboardTypeString];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
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
