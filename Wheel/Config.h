//
//  Config.h
//  Wheel
//
//  Created by Alexander on 26.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define H_CONTENT(className, myProjectName, myName, createdDate, copyrightDate, myCompanyName, superClassName, properties, initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype) [NSString stringWithFormat:@"\
//\n\
//  %@.h\n\
//  %@\n\
//\n\
//  Created by %@ on %@\n\
//  Copyright (c) %@ %@. All rights reserved.\n\
//\n\
\n\
#import <Foundation/Foundation.h>\n\
\n\
@interface %@ : %@ <NSCopying, NSCoding>\n\
%@\n\
%@%@%@\n\
@end\n\n\
",\
className, myProjectName, myName, createdDate, copyrightDate, myCompanyName, className, superClassName, properties, initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype]

#define H_INITWITHDICTIONARY_PROTOTYPE @"\
- (id)initWithDictionary:(NSDictionary *)dictionary;\n\
"

#define H_OBJECTWITHDICTIONARY_PROTOTYPE @"\
- (id)initWithDictionary:(NSDictionary *)dictionary;\n\
"

#define H_OBJECTSWITHARRAY_PROTOTYPE @"\
- (id)initWithDictionary:(NSDictionary *)dictionary;\n\
"

#define H_PROPERTIES(properties) [NSString stringWithFormat:@"\
%@\n\
",\
properties]

#define M_CONTENT(className, myProjectName, myName, createdDate, copyrightDate, myCompanyName, synthesize, dealloc, initWithDictionary, objectWithDictionary, objectsWithArray, copyWithZone, initWithCoder, encodeWithCoder) [NSString stringWithFormat:@"\
//\n\
//  %@.m\n\
//  %@\n\
//\n\
//  Created by %@ on %@\n\
//  Copyright (c) %@ %@. All rights reserved.\n\
//\n\
\n\
#import \"%@.h\"\n\
\n\
@implementation %@\n\
\n\
%@%@%@%@%@%@%@%@@end\n\n\
",\
className, myProjectName, myName, createdDate, copyrightDate, myCompanyName, className, className, synthesize, dealloc, initWithDictionary, objectWithDictionary, objectsWithArray, copyWithZone, initWithCoder, encodeWithCoder]

#define SYNTHESIZE(properties) [NSString stringWithFormat:@"\
%@\n\
",\
properties]

#define DEALLOC(properties) [NSString stringWithFormat:@"\
- (void)dealloc {\n\
%@    [super dealloc];\n\
}\n\n\
",\
properties]

#define DEALLOC(properties) [NSString stringWithFormat:@"\
- (void)dealloc {\n\
%@    [super dealloc];\n\
}\n\n\
",\
properties]

#define INITWITHDICTIONARY(properties) [NSString stringWithFormat:@"\
- (id)initWithDictionary:(NSDictionary *)dictionary {\n\
    self = [super init];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
",\
properties]

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

#define COPYWITHZONE(className, properties) [NSString stringWithFormat:@"\
+ (id)copyWithZone:(NSZone *)zone {\n\
    className *object = [[self class] allocWithZone:zone] init];\n\
%@    return object;\n\
}\n\n\
",\
properties]

#define INITWITHCODER(properties) [NSString stringWithFormat:@"\
- (id)initWithCoder:(NSCoder *)decoder {\n\
    self = [super initWithCoder:decoder];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
",\
properties]

#define ENCODEWITHCODER(properties) [NSString stringWithFormat:@"\
- (void)encodeWithCoder:(NSCoder *)coder {\n\
%@}\n\n\
",\
properties]
