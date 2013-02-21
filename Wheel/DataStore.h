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
@class ImportUnit;
@class ProtocolsUnit;
@class PropertiesUnit;
@class IVarsUnit;
@class PrototypesUnit;
@class DefinesUnit;
@class SynthesizesUnit;
@class DeallocUnit;
@class InstanceUnit;
@class SetAttributesWithDictionaryUnit;
@class InitWithDictionaryUnit;
@class ObjectWithDictionaryUnit;
@class ObjectsWithArrayUnit;
@class DictionaryRepresentationUnit;
@class DescriptionUnit;
@class NSCopyingUnit;
@class NSCodingUnit;
@class ARCUnit;
@class ModernSyntaxUnit;

@interface DataStore : NSObject

@property NSMutableArray *setters;
@property NSMutableArray *atomicities;
@property NSMutableArray *writabilities;
@property NSMutableArray *kinds;
@property NSArray *types;
@property NSIndexSet *selectedTypes;
@property NSArray *units;

@property HContentUnit *HContentUnit;
@property MContentUnit *MContentUnit;
@property HeaderUnit *headerUnit;
@property ImportUnit *importUnit;
@property ProtocolsUnit *protocolsUnit;
@property IVarsUnit *iVarsUnit;
@property PropertiesUnit *propertiesUnit;
@property PrototypesUnit *prototypesUnit;
@property DefinesUnit *definesUnit;
@property SynthesizesUnit *synthesizesUnit;
@property DeallocUnit *deallocUnit;
@property InstanceUnit *instanceUnit;
@property SetAttributesWithDictionaryUnit *setAttributesWithDictionaryUnit;
//NOTE: id type make this method ARC compliant
@property id initWithDictionaryUnit;
@property ObjectWithDictionaryUnit *objectWithDictionaryUnit;
@property ObjectsWithArrayUnit *objectsWithArrayUnit;
@property DictionaryRepresentationUnit *dictionaryRepresentationUnit;
@property DescriptionUnit *descriptionUnit;
@property NSCopyingUnit *copyingUnit;
@property NSCodingUnit *codingUnit;
@property ARCUnit *ARCUnit;
@property ModernSyntaxUnit *modernSyntaxUnit;

+ (DataStore *)sharedDataStore;

- (void)addType;
- (void)removeSelectedTypes;

@end
