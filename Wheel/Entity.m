//
//  PersonModel.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity

@synthesize setter = _setter;
@synthesize atomicity = _atomicity;
@synthesize writability = _writability;
@synthesize type = _type;
@synthesize name = _name;

- (NSString *)h_propertyStuff {
    return [NSString stringWithFormat:@"@property (%@, %@, %@) %@%@;\n", self.setter, self.atomicity, self.writability, self.type, self.name];
}

- (NSString *)m_synthesizeStuff {
    return [NSString stringWithFormat:@"@synthesize %@ = _%@;\n", self.name, self.name];
}

- (NSString *)m_deallocStuff {
    return [NSString stringWithFormat:@"    [_%@ release];\n", self.name];
}

- (NSString *)m_initWithDictionaryStuff {
    return [NSString stringWithFormat:@"        self.%@ = [dictionary objectForKey:@\"%@\"];\n", self.name, self.name];
}

- (NSString *)m_dictionaryRepresentationStuff {
    return [NSString stringWithFormat:@"    [dictionary setObject:self.%@ forKey:@\"%@\"];\n", self.name, self.name];
}

- (NSString *)m_descriptionStuff {
    return [NSString stringWithFormat:@"    %@\n", self.name, self.name];
}

- (NSString *)m_copyWithZoneStuff {
    return [NSString stringWithFormat:@"    object.%@ = self.%@;\n", self.name, self.name];
}

- (NSString *)m_initWithCoderStuff {
    return [NSString stringWithFormat:@"        self.%@ = [decoder decodeObjectForKey:@\"%@\"];\n", self.name, self.name];
}

- (NSString *)m_encodeWithCoderStuff {
    return [NSString stringWithFormat:@"    [coder encodeObject:self.%@ forKey:\"%@\"];\n", self.name, self.name];
}

@end
