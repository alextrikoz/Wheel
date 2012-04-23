//
//  PersonModel.h
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Entity : NSObject

@property (strong) NSNumber *checked;
@property (strong) NSString *setter;
@property (strong) NSString *atomicity;
@property (strong) NSString *writability;
@property (strong) NSString *type;
@property (strong) NSString *name;

- (NSString *)propertyFormat;
- (NSString *)synthesizeFormat;
- (NSString *)releaseFormat;
- (NSString *)dictionaryFormat;
- (NSString *)copyFormat;
- (NSString *)coderFormat;
- (NSString *)decoderFormat;

@end
