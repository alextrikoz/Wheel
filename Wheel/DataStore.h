//
//  DataStore.h
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HContentUnit;
@class MContentUnit;
@class HeaderUnit;
@class ProtocolsUnit;
@class PropertiesUnit;
@class IVarsUnit;
@class PrototypesUnit;
@class DefinesUnit;
@class SynthesizesUnit;
@class DeallocUnit;
@class SetAttributesWithDictionaryUnit;
@class InitWithDictionaryUnit;
@class ObjectWithDictionaryUnit;
@class ObjectsWithArrayUnit;
@class DictionaryRepresentationUnit;
@class DescriptionUnit;
@class NSCopyingUnit;
@class NSCodingUnit;
@class ARCUnit;

@interface DataStore : NSObject

@property (strong) NSMutableArray *setters;
@property (strong) NSMutableArray *atomicities;
@property (strong) NSMutableArray *writabilities;
@property (strong) NSArray *types;
@property (strong) NSIndexSet *selectedTypes;
@property (strong) NSArray *units;

@property (strong) HContentUnit *HContentUnit;
@property (strong) MContentUnit *MContentUnit;
@property (strong) HeaderUnit *headerUnit;
@property (strong) ProtocolsUnit *protocolsUnit;
@property (strong) IVarsUnit *iVarsUnit;
@property (strong) PropertiesUnit *propertiesUnit;
@property (strong) PrototypesUnit *prototypesUnit;
@property (strong) DefinesUnit *definesUnit;
@property (strong) SynthesizesUnit *synthesizesUnit;
@property (strong) DeallocUnit *deallocUnit;
@property (strong) SetAttributesWithDictionaryUnit *setAttributesWithDictionaryUnit;
//NOTE: id type make this method ARC compliant
@property (strong) id initWithDictionaryUnit;
@property (strong) ObjectWithDictionaryUnit *objectWithDictionaryUnit;
@property (strong) ObjectsWithArrayUnit *objectsWithArrayUnit;
@property (strong) DictionaryRepresentationUnit *dictionaryRepresentationUnit;
@property (strong) DescriptionUnit *descriptionUnit;
@property (strong) NSCopyingUnit *copyingUnit;
@property (strong) NSCodingUnit *codingUnit;
@property (strong) ARCUnit *ARCUnit;

+ (DataStore *)sharedDataStore;

- (void)loadTypes;
- (void)loadSetters;
- (void)loadAtomicities;
- (void)loadWritabilities;
- (void)loadUnits;

- (void)addType;
- (void)removeSelectedTypes;

@end
