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

@synthesize document = _document;
@synthesize dataStore = _dataStore;

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
    NSString *header = self.h_header;
    NSString *className = self.document.className;
    NSString *superClassName = self.document.superClassName;
    NSString *protocols = self.h_protocols;
    NSString *properties = self.isPropertiesEnabled ? self.h_properties : @"";
    NSString *prototypes = self.h_prototypes;
    return H_CONTENT(header, className, superClassName, protocols, properties, prototypes);
}

- (NSString *)m_header {
    return [self headerWithFileType:@"m"];
}

- (NSString *)m_defines {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_defineStuff]];
    }
    return M_DEFINES(stuff);
}

- (NSString *)m_synthesizes {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

- (NSString *)m_dealloc {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

- (NSString *)m_initWithDictionary {
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
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_dictionaryRepresentationStuff]];
    }
    return M_DICTIONARYREPRESENTATION(stuff);
}

- (NSString *)m_description {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_descriptionStuff]];
    }
    return M_DESCRIPTION(stuff);
}

- (NSString *)m_copyWithZone {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(self.document.className, stuff);
}

- (NSString *)m_initWithCoder {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_initWithCoderStuff]];
    }
    return M_INITWITHCODER(stuff);
}

- (NSString *)m_encodeWithCoder {
    NSString *stuff = @"";
    for (Entity *entity in self.document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_encodeWithCoderStuff]];
    }
    return M_ENCODEWITHCODER(stuff);
}

- (NSString *)m_content {
    NSString *header = self.m_header;
    NSString *className = self.document.className;
    NSString *defines = self.isDefinesEnabled ? self.m_defines : @"";
    NSString *synthesizes = self.isSynthesizesEnabled ? self.m_synthesizes : @"";
    NSString *dealloc = self.isDeallocEnabled ? self.m_dealloc : @"";
    NSString *initWithDictionary = self.isInitWithDictionaryEnabled ? self.m_initWithDictionary : @"";
    NSString *objectWithDictionary = self.isObjectWithDictionaryEnabled ? self.m_objectWithDictionary : @"";
    NSString *objectsWithArray = self.isObjectsWithArrayEnabled ? self.m_objectsWithArray : @"";
    NSString *dictionaryRepresentation = self.isDictionaryRepresentationEnabled ? self.m_dictionaryRepresentation : @"";
    NSString *description = self.isDescriptionEnabled ? self.m_description : @"";
    NSString *copyWithZone = self.isCopyingEnabled ? self.m_copyWithZone : @"";
    NSString *initWithCoder = self.isCodingEnabled ? self.m_initWithCoder : @"";
    NSString *encodeWithCoder = self.isCodingEnabled ? self .m_encodeWithCoder : @"";
    
    return M_CONTENT(header, className, defines, synthesizes, dealloc, initWithDictionary, objectWithDictionary, objectsWithArray, dictionaryRepresentation, description, copyWithZone, initWithCoder, encodeWithCoder);
}

@end
