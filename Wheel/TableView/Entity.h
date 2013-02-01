//
//  PersonModel.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Entity : NSObject <NSCoding, NSPasteboardWriting>

@property NSUndoManager *undoManager;

@property NSString *setter;
@property NSString *atomicity;
@property NSString *writability;
@property NSString *type;
@property NSString *name;
@property NSMutableArray *children;

+ (Entity *)objectWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)objectsWithArray:(NSArray *)array;
- (NSDictionary *)dictionaryRepresentation;

+ (NSTreeNode *)nodeWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)plainStub;
+ (NSTreeNode *)outlineStub;

+ (Entity *)defaultEntity;

- (NSString *)h_iVarStuff;
- (NSString *)h_propertyStuff;
- (NSString *)m_defineStuff;
- (NSString *)m_synthesizeStuff;
- (NSString *)m_deallocStuff;
- (NSString *)m_setAttributesWithDictionaryStuff;
- (NSString *)m_dictionaryRepresentationStuff;
- (NSString *)m_descriptionStuff;
- (NSString *)m_copyWithZoneStuff;
- (NSString *)m_initWithCoderStuff;
- (NSString *)m_encodeWithCoderStuff;

@end
