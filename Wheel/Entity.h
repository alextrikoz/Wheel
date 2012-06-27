//
//  PersonModel.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Entity : NSObject <NSCoding>

@property (strong) NSString *setter;
@property (strong) NSString *atomicity;
@property (strong) NSString *writability;
@property (strong) NSString *type;
@property (strong) NSString *name;

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
