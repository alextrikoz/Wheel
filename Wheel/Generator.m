//
//  Generator.m
//  Wheel
//
//  Created by Alexander on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Generator.h"

#import "Config.h"

#import "Entity.h"
#import "Option.h"
#import "DataStore.h"

#import "Document.h"

@interface Generator ()

@property (strong) DataStore *dataStore;

- (BOOL)isPropertiesEnabled;
- (BOOL)isPrototypesEnabled;
- (BOOL)isDefinesEnabled;
- (BOOL)isSynthesizesEnabled;
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
- (NSString *)h_properties;
- (NSString *)h_prototypes;
- (NSString *)h_initWithDictionaryPrototype;
- (NSString *)h_objectWithDictionaryPrototype;
- (NSString *)h_objectsWithArrayPrototype;
- (NSString *)h_dictionaryRepresentationPrototype;
- (NSString *)h_descriptionPrototype;

- (NSString *)m_header;
- (NSString *)m_defines;
- (NSString *)m_synthesizes;
- (NSString *)m_dealloc;
- (NSString *)m_initWithDictionary;
- (NSString *)m_objectWithDictionary;
- (NSString *)m_objectsWithArray;
- (NSString *)m_dictionaryRepresentation;
- (NSString *)m_description;
- (NSString *)m_copyWithZone;
- (NSString *)m_initWithCoder;
- (NSString *)m_encodeWithCoder;

@end

@implementation Generator

@synthesize dataStore = _dataStore;
@synthesize document = _document;

- (id)init {
    self = [super init];
    if (self) {
        self.dataStore = [[DataStore alloc] init];
    }
    return self;
}

- (BOOL)isPropertiesEnabled {
    return self.document.entities.count;
}

- (BOOL)isPrototypesEnabled {
    return self.isInitWithDictionaryEnabled || self.isObjectWithDictionaryEnabled || self.isObjectsWithArrayEnabled || self.isDictionaryRepresentationEnabled;
}

- (BOOL)isDefinesEnabled {
    return self.document.entities.count && (self.isInitWithDictionaryEnabled || self.isDictionaryRepresentationEnabled);
}

- (BOOL)isSynthesizesEnabled {
    return self.document.entities.count;
}

- (BOOL)isDeallocEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:0]).enabled boolValue] && !self.isARCEnabled;
}

- (BOOL)isInitWithDictionaryEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:1]).enabled boolValue];
}

- (BOOL)isObjectWithDictionaryEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:2]).enabled boolValue];
}

- (BOOL)isObjectsWithArrayEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:3]).enabled boolValue];
}

- (BOOL)isDictionaryRepresentationEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:4]).enabled boolValue];    
}

- (BOOL)isDescriptionEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:5]).enabled boolValue];
}

- (BOOL)isCopyingEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:6]).enabled boolValue];
}

- (BOOL)isCodingEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:7]).enabled boolValue];
}

- (BOOL)isARCEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:8]).enabled boolValue];
}

- (NSString *)headerWithFileType:(NSString *)fileType {
    id defaultValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", self.document.className, fileType];
    NSString *myProjectName = [defaultValues valueForKey:@"MyProjectName"];
    NSString *myName = [defaultValues valueForKey:@"MyName"];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *createdDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *copyrightDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *myCompanyName = [defaultValues valueForKey:@"MyCompanyName"];
    
    return HEADER(fileName, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
}

- (NSString *)h_header {
    return [self headerWithFileType:@"h"];
}

- (NSString *)h_protocols {
    if (self.isCopyingEnabled && self.isCodingEnabled) {
        return @"<NSCopying, NSCoding>";
    } else if (self.isCopyingEnabled) {
        return @"<NSCopying>";
    } else if (self.isCodingEnabled) {
        return @"<NSCoding>";
    } else {
        return @"";
    }
}

- (NSString *)h_properties {
    if (!self.isPropertiesEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity h_propertyStuff]];
    }
    return H_PROPERTIES(stuff);
}

- (NSString *)h_prototypes {
    return self.isPrototypesEnabled ? H_PROTOTYPES(self.h_initWithDictionaryPrototype, self.h_objectWithDictionaryPrototype, self.h_objectsWithArrayPrototype, self.h_dictionaryRepresentationPrototype, self.h_descriptionPrototype) : @"";
}

- (NSString *)h_initWithDictionaryPrototype {
    return self.isInitWithDictionaryEnabled ? H_INITWITHDICTIONARY_PROTOTYPE(self.document.className) : @"";
}

- (NSString *)h_objectWithDictionaryPrototype {
    return self.isObjectWithDictionaryEnabled ? H_OBJECTWITHDICTIONARY_PROTOTYPE(self.document.className) : @"";
}

- (NSString *)h_objectsWithArrayPrototype {
    return self.isObjectsWithArrayEnabled ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
}

- (NSString *)h_dictionaryRepresentationPrototype {
    return self.isDictionaryRepresentationEnabled ? M_DICTIONARYREPRESENTATION_PROTOTYPE : @"";
}

- (NSString *)h_descriptionPrototype {
    return self.isDescriptionEnabled ? H_DESCRIPTION_PROTOTYPE : @"";
}

- (NSString *)h_content {    
    return H_CONTENT(self.h_header, self.document.className, self.document.superClassName, self.h_protocols, self.h_properties, self.h_prototypes);
}

- (NSString *)m_header {
    return [self headerWithFileType:@"m"];
}

- (NSString *)m_defines {
    if (!self.isDefinesEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_defineStuff]];
    }
    return M_DEFINES(stuff);
}

- (NSString *)m_synthesizes {
    if (!self.isSynthesizesEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

- (NSString *)m_dealloc {
    if (!self.isDeallocEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

- (NSString *)m_initWithDictionary {
    if (!self.isInitWithDictionaryEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithDictionaryStuff]];
    }
    return M_INITWITHDICTIONARY(self.document.className, stuff);
}

- (NSString *)m_objectWithDictionary {
    return self.isObjectWithDictionaryEnabled ? self.isARCEnabled ? M_OBJECTWITHDICTIONARY_ARC(self.document.className) : M_OBJECTWITHDICTIONARY_MRR(self.document.className) : @"";
}

- (NSString *)m_objectsWithArray {
    return self.isObjectsWithArrayEnabled ? M_OBJECTSWITHARRAY : @"";
}

- (NSString *)m_dictionaryRepresentation {
    if (!self.isDictionaryRepresentationEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_dictionaryRepresentationStuff]];
    }
    return M_DICTIONARYREPRESENTATION(stuff);
}

- (NSString *)m_description {
    if (!self.isDescriptionEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_descriptionStuff]];
    }
    return M_DESCRIPTION(stuff);
}

- (NSString *)m_copyWithZone {
    if (!self.isCopyingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(self.document.className, stuff);
}

- (NSString *)m_initWithCoder {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithCoderStuff]];
    }
    return M_INITWITHCODER(stuff);
}

- (NSString *)m_encodeWithCoder {
    if (!self.isCodingEnabled) {
        return @"";
    }
    
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_encodeWithCoderStuff]];
    }
    return M_ENCODEWITHCODER(stuff);
}

- (NSString *)m_content {
    return M_CONTENT(self.m_header, self.document.className, self.m_defines, self.m_synthesizes, self.m_dealloc, self.m_initWithDictionary, self.m_objectWithDictionary, self.m_objectsWithArray, self.m_dictionaryRepresentation, self.m_description, self.m_copyWithZone, self.m_initWithCoder, self .m_encodeWithCoder);
}

@end
