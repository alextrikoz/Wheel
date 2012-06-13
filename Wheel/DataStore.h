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

- (BOOL)isDeallocEnabled;
- (BOOL)isInitWithDictionaryEnabled;
- (BOOL)isObjectWithDictionaryEnabled;
- (BOOL)isObjectsWithArrayEnabled;
- (BOOL)isDictionaryRepresentationEnabled;
- (BOOL)isDescriptionEnabled;
- (BOOL)isCopyingEnabled;
- (BOOL)isCodingEnabled;
- (BOOL)isARCEnabled;

@end
