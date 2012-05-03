//
//  PersonModel.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity

@synthesize checked = _checked;
@synthesize setter = _setter;
@synthesize atomicity = _atomicity;
@synthesize writability = _writability;
@synthesize type = _type;
@synthesize name = _name;

- (NSString *)propertyFormat {
    return [NSString stringWithFormat:@"@property (%@, %@, %@) %@%@;\n", self.setter, self.atomicity, self.writability, self.type, self.name];
}

- (NSString *)synthesizeFormat {
    return [NSString stringWithFormat:@"@synthesize %@ = _%@;\n", self.name, self.name];
}

- (NSString *)releaseFormat {
    return [NSString stringWithFormat:@"    [_%@ release];\n", self.name];
}

- (NSString *)dictionaryFormat {
    return [NSString stringWithFormat:@"        self.%@ = [dictionary objectForKey:@\"%@\"];\n", self.name, self.name];
}

- (NSString *)copyFormat {
    return [NSString stringWithFormat:@"    object.%@ = self.%@;\n", self.name, self.name];
}

- (NSString *)coderFormat {
    return [NSString stringWithFormat:@"    [coder encodeObject:self.%@ forKey:\"%@\"];\n", self.name, self.name];
}

- (NSString *)decoderFormat {
    return [NSString stringWithFormat:@"        self.%@ = [decoder decodeObjectForKey:@\"%@\"];\n", self.name, self.name];
}

@end
