//
//  Method.h
//  Wheel
//
//  Created by Alexander on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Document;

@protocol UnitProtocol <NSObject>

@optional
- (NSString *)prototypeWithDocument:(Document *)document;
- (NSString *)bodyWithDocument:(Document *)document;
- (NSString *)bodyWithDocument:(Document *)document pathExtension:(NSString *)pathExtension;

@end

@interface Unit : NSObject

@property (strong) NSString *name;
@property (strong) NSNumber *visible;
@property (strong) NSNumber *enable;
@property (strong) NSNumber *on;

- (BOOL)available;

@end

@interface HeaderUnit : Unit <UnitProtocol> @end
@interface DefinesUnit : Unit <UnitProtocol> @end
@interface SynthesizesUnit : Unit <UnitProtocol> @end
@interface DeallocUnit : Unit <UnitProtocol> @end
@interface SetAttributesWithDictionaryUnit : Unit <UnitProtocol> @end
@interface InitWithDictionaryUnit : Unit <UnitProtocol> @end
@interface ObjectWithDictionaryUnit : Unit <UnitProtocol> @end
@interface ObjectsWithArrayUnit : Unit <UnitProtocol> @end
@interface DictionaryRepresentationUnit : Unit <UnitProtocol> @end
@interface DescriptionUnit : Unit <UnitProtocol> @end
@interface NSCopyingUnit : Unit <UnitProtocol> @end
@interface NSCodingUnit : Unit <UnitProtocol> @end
