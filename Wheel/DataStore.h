//
//  DataStore.h
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

@property (strong) NSMutableArray *setters;
@property (strong) NSMutableArray *atomicities;
@property (strong) NSMutableArray *writabilities;
@property (strong) NSArray *types;
@property (strong) NSIndexSet *selectedTypes;
@property (strong) NSArray *options;

- (void)loadTypes;
- (void)loadSetters;
- (void)loadAtomicities;
- (void)loadWritabilities;
- (void)loadOptions;

- (void)addType;
- (void)removeSelectedTypes;

- (BOOL)isPropertiesEnabled:(NSArray *)entities;
- (BOOL)isPrototypesEnabled;
- (BOOL)isDefinesEnabled:(NSArray *)entities;
- (BOOL)isSynthesizesEnabled:(NSArray *)entities;
- (BOOL)isDeallocEnabled;
- (BOOL)isInitWithDictionaryEnabled;
- (BOOL)isObjectWithDictionaryEnabled;
- (BOOL)isObjectsWithArrayEnabled;
- (BOOL)isDictionaryRepresentationEnabled;
- (BOOL)isDescriptionEnabled;
- (BOOL)isCopyingEnabled;
- (BOOL)isCodingEnabled;
- (BOOL)isARCEnabled;

- (NSString *)headerWithFileType:(NSString *)fileType;

- (NSString *)h_header;
- (NSString *)h_protocols;
- (NSString *)h_properties:(NSArray *)entities;
- (NSString *)h_prototypes;
- (NSString *)h_initWithDictionaryPrototype;
- (NSString *)h_objectWithDictionaryPrototype;
- (NSString *)h_objectsWithArrayPrototype;
- (NSString *)h_dictionaryRepresentationPrototype;
- (NSString *)h_descriptionPrototype;
- (NSString *)h_content:(NSArray *)entities className:(NSString *)className superClassName:(NSString *)superClassName;

- (NSString *)m_header;
- (NSString *)m_defines:(NSArray *)entities;
- (NSString *)m_synthesizes:(NSArray *)entities;
- (NSString *)m_dealloc:(NSArray *)entities;
- (NSString *)m_initWithDictionary:(NSArray *)entities;
- (NSString *)m_objectWithDictionary;
- (NSString *)m_objectsWithArray;
- (NSString *)m_dictionaryRepresentation:(NSArray *)entities;
- (NSString *)m_description:(NSArray *)entities;
- (NSString *)m_copyWithZone:(NSArray *)entities;
- (NSString *)m_initWithCoder:(NSArray *)entities;
- (NSString *)m_encodeWithCoder:(NSArray *)entities;
- (NSString *)m_content:(NSArray *)entities className:(NSString *)className;

@end
