//
//  Config.h
//  Wheel
//
//  Created by Alexander on 26.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SYNTHESIZE(properties) [NSString stringWithFormat:@"\
%@\n\
"\
, properties]

#define DEALLOC(properties) [NSString stringWithFormat:@"\
- (void)dealloc {\n\
%@    [super dealloc];\n\
}\n\n\
"\
, properties]

#define DEALLOC(properties) [NSString stringWithFormat:@"\
- (void)dealloc {\n\
%@    [super dealloc];\n\
}\n\n\
"\
, properties]

#define INITWITHDICTIONARY(properties) [NSString stringWithFormat:@"\
- (id)initWithDictionary:(NSDictionary *)dictionary {\n\
    self = [super init];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
"\
, properties]

#define OBJECTWITHDICTIONARY @"\
+ (id)objectWithDictionary:(NSDictionary *)dictionary {\n\
    return [[[self alloc] initWithDictionary:dictionary] autorelease];\n\
}\n\n\
"

#define OBJECTSWITHARRAY @"\
+ (NSArray *)objectsWithArray:(NSArray *)array {\n\
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:array.count];\n\
    for(NSDictionary *dictionary in array) {\n\
        [objects addObject:[self objectWithDictionary:dictionary]];\n\
    }\n\
    return objects;\n\
}\n\n\
"

#define COPYWITHZONE(properties) [NSString stringWithFormat:@"\
+ (id)copyWithZone:(NSZone *)zone {\n\
    Model *object = [[self class] allocWithZone:zone] init];\n\
%@    return object;\n\
}\n\n\
"\
, properties]

#define INITWITHCODER(properties) [NSString stringWithFormat:@"\
- (id)initWithCoder:(NSCoder *)decoder {\n\
    self = [super init];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
"\
, properties]

#define ENCODEWITHCODER(properties) [NSString stringWithFormat:@"\
- (void)encodeWithCoder:(NSCoder *)coder {\n\
%@}\n\n\
"\
, properties]
