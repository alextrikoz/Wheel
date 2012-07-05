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
#import "Unit.h"

@interface Generator ()

@property (strong) DataStore *dataStore;

- (BOOL)isPropertiesEnabled;
- (BOOL)isPrototypesEnabled;
- (BOOL)isDefinesEnabled;
- (BOOL)isSynthesizesEnabled;
- (BOOL)isDeallocEnabled;
- (BOOL)isSetAttributesWithDictionaryEnabled;
- (BOOL)isInitWithDictionaryEnabled;
- (BOOL)isObjectWithDictionaryEnabled;
- (BOOL)isObjectsWithArrayEnabled;
- (BOOL)isDictionaryRepresentationEnabled;
- (BOOL)isDescriptionEnabled;
- (BOOL)isCopyingEnabled;
- (BOOL)isCodingEnabled;
- (BOOL)isARCEnabled;

- (NSString *)h_protocols;
- (NSString *)h_properties;
- (NSString *)h_prototypes;
- (NSString *)h_setAttributesWithDictionary;
- (NSString *)h_initWithDictionaryPrototype;
- (NSString *)h_objectWithDictionaryPrototype;
- (NSString *)h_objectsWithArrayPrototype;
- (NSString *)h_dictionaryRepresentationPrototype;
- (NSString *)h_descriptionPrototype;

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
    return self.isSetAttributesWithDictionaryEnabled || self.isInitWithDictionaryEnabled || self.isObjectWithDictionaryEnabled || self.isObjectsWithArrayEnabled || self.isDictionaryRepresentationEnabled;
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

- (BOOL)isSetAttributesWithDictionaryEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:1]).enabled boolValue];
}

- (BOOL)isInitWithDictionaryEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:2]).enabled boolValue];
}

- (BOOL)isObjectWithDictionaryEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:3]).enabled boolValue];
}

- (BOOL)isObjectsWithArrayEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:4]).enabled boolValue];
}

- (BOOL)isDictionaryRepresentationEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:5]).enabled boolValue];
}

- (BOOL)isDescriptionEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:6]).enabled boolValue];
}

- (BOOL)isCopyingEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:7]).enabled boolValue];
}

- (BOOL)isCodingEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:8]).enabled boolValue];
}

- (BOOL)isARCEnabled {
    return [((Option *)[self.dataStore.options objectAtIndex:9]).enabled boolValue];
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
    return self.isPrototypesEnabled ? H_PROTOTYPES(self.h_setAttributesWithDictionary, self.h_initWithDictionaryPrototype, self.h_objectWithDictionaryPrototype, self.h_objectsWithArrayPrototype, self.h_dictionaryRepresentationPrototype, self.h_descriptionPrototype) : @"";
}

- (NSString *)h_setAttributesWithDictionary {
    return self.isSetAttributesWithDictionaryEnabled ? H_SETATTRIBUTESWITHDICTIONARY_PROTOTYPE : @"";
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
    HeaderUnit *headerUnit = [[HeaderUnit alloc] init];
    headerUnit.enable = [NSNumber numberWithBool:YES];
    headerUnit.on = [NSNumber numberWithBool:YES];
    NSString *header = [headerUnit bodyWithDocument:self.document pathExtension:@"h"];
    
    NSString *className = self.document.className;
    NSString *superClassName = self.document.superClassName;
    
    NSString *protocols = self.h_protocols;
    NSString *properties = self.isPropertiesEnabled ? self.h_properties : @"";
    NSString *prototypes = self.h_prototypes;
    return H_CONTENT(header, className, superClassName, protocols, properties, prototypes);
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

- (Option *)DeallocOption {
    return [self.dataStore.options objectAtIndex:0];
}

- (Option *)SetAttributesWithDictionaryOption {
    return [self.dataStore.options objectAtIndex:1];
}

- (Option *)InitWithDictionaryOption {
    return [self.dataStore.options objectAtIndex:2];
}

- (Option *)ObjectWithDictionaryOption {
    return [self.dataStore.options objectAtIndex:3];
}

- (Option *)ObjectsWithArrayOption {
    return [self.dataStore.options objectAtIndex:4];
}

- (Option *)DictionaryRepresentationOption {
    return [self.dataStore.options objectAtIndex:5];
}

- (Option *)DescriptionOption {
    return [self.dataStore.options objectAtIndex:6];
}

- (Option *)CopyingOption {
    return [self.dataStore.options objectAtIndex:7];
}

- (Option *)CodingOption {
    return [self.dataStore.options objectAtIndex:8];
}

- (Option *)ARCOption {
    return [self.dataStore.options objectAtIndex:9];
}

- (NSString *)m_content {    
    HeaderUnit *headerUnit = [[HeaderUnit alloc] init];
    headerUnit.enable = [NSNumber numberWithBool:YES];
    headerUnit.on = [NSNumber numberWithBool:YES];
    NSString *header = [headerUnit bodyWithDocument:self.document pathExtension:@"m"];
    
    NSString *className = self.document.className;
    
    DefinesUnit *definesUnit = [[DefinesUnit alloc] init];
    definesUnit.enable = [NSNumber numberWithBool:YES];
    definesUnit.on = [NSNumber numberWithBool:YES];
    NSString *defines = [definesUnit bodyWithDocument:self.document];
    
    SynthesizesUnit *synthesizesUnit = [[SynthesizesUnit alloc] init];
    synthesizesUnit.enable = [NSNumber numberWithBool:YES];
    synthesizesUnit.on = [NSNumber numberWithBool:YES];
    NSString *synthesizes = [synthesizesUnit bodyWithDocument:self.document];
    
    DeallocUnit *deallocUnit = [[DeallocUnit alloc] init];
    deallocUnit.enable = self.DeallocOption.active;
    deallocUnit.on = self.DeallocOption.enabled;
    NSString *dealloc = [deallocUnit bodyWithDocument:self.document];
    
    SetAttributesWithDictionaryUnit *setAttributesWithDictionaryUnit = [[SetAttributesWithDictionaryUnit alloc] init];
    setAttributesWithDictionaryUnit.enable = self.SetAttributesWithDictionaryOption.active;
    setAttributesWithDictionaryUnit.on = self.SetAttributesWithDictionaryOption.enabled;
    NSString *setAttributesWithDictionary = [setAttributesWithDictionaryUnit bodyWithDocument:self.document];
    
    InitWithDictionaryUnit *initWithDictionaryUnit = [[InitWithDictionaryUnit alloc] init];
    initWithDictionaryUnit.enable = self.InitWithDictionaryOption.active;
    initWithDictionaryUnit.on = self.InitWithDictionaryOption.enabled;
    NSString *initWithDictionary = [initWithDictionaryUnit bodyWithDocument:self.document];
    
    ObjectWithDictionaryUnit *objectWithDictionaryUnit = [[ObjectWithDictionaryUnit alloc] init];
    objectWithDictionaryUnit.enable = self.ObjectWithDictionaryOption.active;
    objectWithDictionaryUnit.on = self.ObjectWithDictionaryOption.enabled;
    NSString *objectWithDictionary = [objectWithDictionaryUnit bodyWithDocument:self.document];
    
    ObjectsWithArrayUnit *objectsWithArrayUnit = [[ObjectsWithArrayUnit alloc] init];
    objectsWithArrayUnit.enable = self.ObjectsWithArrayOption.active;
    objectsWithArrayUnit.on = self.ObjectsWithArrayOption.enabled;
    NSString *objectsWithArray = [objectsWithArrayUnit bodyWithDocument:self.document];
    
    DictionaryRepresentationUnit *dictionaryRepresentationUnit = [[DictionaryRepresentationUnit alloc] init];
    dictionaryRepresentationUnit.enable = self.DictionaryRepresentationOption.active;
    dictionaryRepresentationUnit.on = self.DictionaryRepresentationOption.enabled;
    NSString *dictionaryRepresentation = [dictionaryRepresentationUnit bodyWithDocument:self.document];
    
    DescriptionUnit *descriptionUnit = [[DescriptionUnit alloc] init];
    descriptionUnit.enable = self.DescriptionOption.active;
    descriptionUnit.on = self.DescriptionOption.enabled;
    NSString *description = [descriptionUnit bodyWithDocument:self.document];
    
    NSCopyingUnit *copyingUnit = [[NSCopyingUnit alloc] init];
    copyingUnit.enable = self.CopyingOption.active;
    copyingUnit.on = self.CopyingOption.enabled;
    NSString *copyWithZone = [copyingUnit bodyWithDocument:self.document];
    
    NSString *initWithCoder = self.isCodingEnabled ? self.m_initWithCoder : @"";
    NSString *encodeWithCoder = self.isCodingEnabled ? self .m_encodeWithCoder : @"";
    
    return M_CONTENT(header, className, defines, synthesizes, dealloc, setAttributesWithDictionary, initWithDictionary, objectWithDictionary, objectsWithArray, dictionaryRepresentation, description, copyWithZone, initWithCoder, encodeWithCoder);
}

@end
