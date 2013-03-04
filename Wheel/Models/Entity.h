//
//  PersonModel.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Entity : NSObject <NSPasteboardWriting, NSCoding>

@property BOOL enabled;
@property NSString *setter;
@property NSString *atomicity;
@property NSString *writability;
@property NSString *type;
@property NSString *name;
@property NSString *key;
@property NSString *kind;
@property NSString *className;
@property NSString *superClassName;
@property NSMutableArray *children;

- (NSString *)h_iVarStuff;
- (NSString *)h_propertyStuff;
- (NSString *)h_importStuff;
- (NSString *)m_importStuff;
- (NSString *)m_defineStuff;
- (NSString *)m_synthesizeStuff;
- (NSString *)m_deallocStuff;
- (NSString *)m_setAttributesWithDictionaryStuff;
- (NSString *)m_dictionaryRepresentationStuff;
- (NSString *)m_descriptionStuff;
- (NSString *)m_copyWithZoneStuff;
- (NSString *)m_initWithCoderStuff;
- (NSString *)m_encodeWithCoderStuff;

+ (Entity *)objectWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)objectsWithArray:(NSArray *)array;
- (NSMutableDictionary *)dictionaryRepresentation;
+ (NSTreeNode *)nodeWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)dictionaryWithNode:(NSTreeNode *)node;

+ (NSMutableArray *)plainStub;
+ (NSTreeNode *)outlineStub;
+ (Entity *)objectStub;

+ (Entity *)entityWithInfo:(id)object;

@end
