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
    [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setSetter:_setter];
    _setter = setter;
}

- (NSString *)setter {
    return _setter;
}

#pragma mark - atomicity

@synthesize atomicity = _atomicity;

- (void)setAtomicity:(NSString *)atomicity {
    [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setAtomicity:_atomicity];
    _atomicity = atomicity;
}

- (NSString *)atomicity {
    return _atomicity;
}

#pragma mark - writability

@synthesize writability = _writability;

- (void)setWritability:(NSString *)writability {
    [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setWritability:_writability];
    _writability = writability;
}

- (NSString *)writability {
    return _writability;
}

#pragma mark - type

@synthesize type = _type;

- (void)setType:(NSString *)type {
    [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setType:_type];
    _type = type;
}

- (NSString *)type {
    return _type;
}

#pragma mark - name

@synthesize name = _name;

- (void)setName:(NSString *)name {
    [(Entity *)[self.undoManager prepareWithInvocationTarget:self] setName:_name];
    _name = name;
}

- (NSString *)name {
    return _name;
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeString];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - gentrator

- (NSString *)h_iVarStuff {
    return [NSString stringWithFormat:@"    %@_%@;\n", self.type, self.name];
}

- (NSString *)h_propertyStuff {
    NSString *atomicity = [self.atomicity isEqualToString:@"nonatomic"] ? @", nonatomic" : @"";
    NSString *writability = [self.writability isEqualToString:@"readonly"] ? @", readonly" : @"";
    
    NSString *type = self.type;
    if ([type rangeOfString:@"*"].location == NSNotFound && [type rangeOfString:@" "].location == NSNotFound) {
        type = [type stringByAppendingString:@" "];
    }
    return [NSString stringWithFormat:@"@property (%@%@%@) %@%@;\n", self.setter, atomicity, writability, type, self.name];
}

- (NSString *)m_defineStuff {
    return [NSString stringWithFormat:@"#define %@_KEY @\"%@\"\n", self.name.uppercaseString, self.name];
}

- (NSString *)m_synthesizeStuff {
    return [NSString stringWithFormat:@"@synthesize %@ = _%@;\n", self.name, self.name];
}

- (NSString *)m_deallocStuff {
    return [NSString stringWithFormat:@"    [_%@ release];\n", self.name];
}

- (NSString *)m_setAttributesWithDictionaryStuff {
    return [NSString stringWithFormat:@"    self.%@ = [dictionary objectForKey:%@_KEY];\n", self.name, self.name.uppercaseString];
}

- (NSString *)m_dictionaryRepresentationStuff {
    return [NSString stringWithFormat:@"    [dictionary setObject:self.%@ forKey:%@_KEY];\n", self.name, self.name.uppercaseString];
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

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.setter forKey:@"setter"];
    [coder encodeObject:self.atomicity forKey:@"atomicity"];
    [coder encodeObject:self.writability forKey:@"writability"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.setter = [decoder decodeObjectForKey:@"setter"];
        self.atomicity = [decoder decodeObjectForKey:@"atomicity"];
        self.writability = [decoder decodeObjectForKey:@"writability"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end