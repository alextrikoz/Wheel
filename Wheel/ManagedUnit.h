//
//  ManagedUnit.h
//  Wheel
//
//  Created by Alexander on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedUnit : NSManagedObject

@property (nonatomic, retain) NSNumber * enable;
@property (nonatomic, retain) NSNumber * on;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;

+ (ManagedUnit *)managedUnitWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (BOOL)available;

@end

@class TableDocument;

@protocol UnitProtocol <NSObject>

@optional
- (NSString *)prototypeWithDocument:(TableDocument *)document;
- (NSString *)bodyWithDocument:(TableDocument *)document;
- (NSString *)bodyWithDocument:(TableDocument *)document pathExtension:(NSString *)pathExtension;

@end

@interface Unit : NSObject <UnitProtocol>

@property (strong) ManagedUnit *managedUnit;

- (BOOL)available;

@end

@interface HContentUnit : Unit  @end
@interface MContentUnit : Unit @end

@interface HeaderUnit : Unit @end
@interface ImportUnit : Unit @end
@interface ProtocolsUnit : Unit  @end
@interface IVarsUnit : Unit  @end
@interface PropertiesUnit : Unit @end
@interface PrototypesUnit : Unit  @end
@interface DefinesUnit : Unit @end
@interface SynthesizesUnit : Unit @end
@interface DeallocUnit : Unit @end
@interface SetAttributesWithDictionaryUnit : Unit @end
@interface InitWithDictionaryUnit : Unit @end
@interface ObjectWithDictionaryUnit : Unit @end
@interface ObjectsWithArrayUnit : Unit @end
@interface DictionaryRepresentationUnit : Unit @end
@interface DescriptionUnit : Unit @end
@interface NSCopyingUnit : Unit @end
@interface NSCodingUnit : Unit @end
@interface ARCUnit : Unit @end
