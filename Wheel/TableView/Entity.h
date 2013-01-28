//
//  PersonModel.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Entity : NSObject <NSCoding>

@property NSUndoManager *undoManager;

@property NSString *setter;
@property NSString *atomicity;
@property NSString *writability;
@property NSString *type;
@property NSString *name;

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
