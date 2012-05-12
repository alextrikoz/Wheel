//
//  DataStore.h
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

@property (copy) NSString *className;
@property (copy) NSString *superClassName;

@property (strong) NSMutableArray *setters;
@property (strong) NSMutableArray *atomicities;
@property (strong) NSMutableArray *writabilities;
@property (strong) NSMutableArray *types;
@property (strong) NSMutableArray *entities;
@property (strong) NSMutableArray *options;

- (BOOL)isPropertiesEnabled;
- (BOOL)isPrototypesEnabled;
- (BOOL)isDeallocEnabled;
- (BOOL)isInitWithDictionaryEnabled;
- (BOOL)isObjectWithDictionaryEnabled;
- (BOOL)isObjectsWithArrayEnabled;
- (BOOL)isCopyingEnabled;
- (BOOL)isCodingEnabled;

- (NSString *)headerWithFileType:(NSString *)fileType;

- (NSString *)h_header;
- (NSString *)h_protocols;
- (NSString *)h_properties;
- (NSString *)h_initWithDictionaryPrototype;
- (NSString *)h_objectWithDictionaryPrototype;
- (NSString *)h_objectsWithArrayPrototype;
- (NSString *)h_prototypes;
- (NSString *)h_content;

- (NSString *)m_header;
- (NSString *)m_synthesizes;
- (NSString *)m_dealloc;
- (NSString *)m_initWithDictionary;
- (NSString *)m_objectWithDictionary;
- (NSString *)m_objectsWithArrayEnabled;
- (NSString *)m_copyWithZone;
- (NSString *)m_initWithCoder;
- (NSString *)m_encodeWithCoder;
- (NSString *)m_content;

@end
