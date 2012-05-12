//
//  Config.h
//  Wheel
//
//  Created by Alexander on 26.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define HEADER(fileName, myProjectName, myName, createdDate, copyrightDate, myCompanyName) [NSString stringWithFormat:@"\
//\n\
//  %@\n\
//  %@\n\
//\n\
//  Created by %@ on %@\n\
//  Copyright (c) %@ %@. All rights reserved.\n\
//\n\
\n\
",\
fileName, myProjectName, myName, createdDate, copyrightDate, myCompanyName]

#define H_CONTENT(header, className, superClassName, protocols, properties, prototypes) [NSString stringWithFormat:@"\
%@#import <Foundation/Foundation.h>\n\
\n\
@interface %@ : %@ %@\n\
\n\
%@%@\
@end\n\
",\
header, className, superClassName, protocols, properties, prototypes]

#define H_PROPERTIES(properties) [NSString stringWithFormat:@"\
%@\n\
",\
properties]

#define H_PROTOTYPES(initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype) [NSString stringWithFormat:@"\
%@%@%@\n\
",\
initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype]

#define H_INITWITHDICTIONARY_PROTOTYPE @"\
- (id)initWithDictionary:(NSDictionary *)dictionary;\n\
"

#define H_OBJECTWITHDICTIONARY_PROTOTYPE @"\
- (id)objectWithDictionary:(NSDictionary *)dictionary;\n\
"

#define H_OBJECTSWITHARRAY_PROTOTYPE @"\
- (NSMutableArray *)objectsWithArray:(NSArray *)array;\n\
"

#define M_CONTENT(header, className, synthesize, dealloc, initWithDictionary, objectWithDictionary, objectsWithArray, copyWithZone, initWithCoder, encodeWithCoder) [NSString stringWithFormat:@"\
%@#import \"%@.h\"\n\
\n\
@implementation %@\n\
\n\
%@%@%@%@%@%@%@%@\
@end\n\
",\
header, className, className, synthesize, dealloc, initWithDictionary, objectWithDictionary, objectsWithArray, copyWithZone, initWithCoder, encodeWithCoder]

#define M_SYNTHESIZES(properties) [NSString stringWithFormat:@"\
%@\n\
",\
properties]

#define M_DEALLOC(properties) [NSString stringWithFormat:@"\
- (void)dealloc {\n\
%@    [super dealloc];\n\
}\n\n\
",\
properties]

#define M_INITWITHDICTIONARY(properties) [NSString stringWithFormat:@"\
- (id)initWithDictionary:(NSDictionary *)dictionary {\n\
    self = [super init];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
",\
properties]

#define M_OBJECTWITHDICTIONARY @"\
+ (id)objectWithDictionary:(NSDictionary *)dictionary {\n\
    return [[[self alloc] initWithDictionary:dictionary] autorelease];\n\
}\n\n\
"

#define M_OBJECTSWITHARRAY @"\
+ (NSMutableArray *)objectsWithArray:(NSArray *)array {\n\
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:array.count];\n\
    for(NSDictionary *dictionary in array) {\n\
        [objects addObject:[self objectWithDictionary:dictionary]];\n\
    }\n\
    return objects;\n\
}\n\n\
"

#define M_COPYWITHZONE(className, properties) [NSString stringWithFormat:@"\
#pragma mark - NSCoding\n\
\n\
+ (id)copyWithZone:(NSZone *)zone {\n\
    %@ *object = [[self class] allocWithZone:zone] init];\n\
%@    return object;\n\
}\n\n\
",\
className, properties]

#define M_INITWITHCODER(properties) [NSString stringWithFormat:@"\
#pragma mark - NSCoding\n\
\n\
- (id)initWithCoder:(NSCoder *)decoder {\n\
    self = [super initWithCoder:decoder];\n\
    if (self) {\n\
%@    }\n\
    return self;\n\
}\n\n\
",\
properties]

#define M_ENCODEWITHCODER(properties) [NSString stringWithFormat:@"\
- (void)encodeWithCoder:(NSCoder *)coder {\n\
%@}\n\n\
",\
properties]
