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
#import "ManagedUnit.h"
#import "DataStore.h"
#import "Document.h"

@interface Generator ()

@property (strong) DataStore *dataStore;

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

- (NSString *)h_content {
    NSString *header = [self.dataStore.headerUnit bodyWithDocument:self.document pathExtension:@"h"];
    NSString *className = self.document.className;
    NSString *superClassName = self.document.superClassName;
    NSString *protocols = [self.dataStore.protocolsUnit bodyWithDocument:self.document];
    NSString *properties = [self.dataStore.propertiesUnit bodyWithDocument:self.document];
    NSString *prototypes = [self.dataStore.prototypesUnit bodyWithDocument:self.document];
    
    return H_CONTENT(header, className, superClassName, protocols, properties, prototypes);
}

- (NSString *)m_content {
    NSString *header = [self.dataStore.headerUnit bodyWithDocument:self.document pathExtension:@"m"];
    NSString *className = self.document.className;
    NSString *defines = [self.dataStore.definesUnit bodyWithDocument:self.document];
    NSString *synthesizes = [self.dataStore.synthesizesUnit bodyWithDocument:self.document];
    NSString *dealloc = [self.dataStore.deallocUnit bodyWithDocument:self.document];
    NSString *setAttributesWithDictionary = [self.dataStore.setAttributesWithDictionaryUnit bodyWithDocument:self.document];
    NSString *initWithDictionary = [self.dataStore.initWithDictionaryUnit bodyWithDocument:self.document];
    NSString *objectWithDictionary = [self.dataStore.objectWithDictionaryUnit bodyWithDocument:self.document];
    NSString *objectsWithArray = [self.dataStore.objectsWithArrayUnit bodyWithDocument:self.document];
    NSString *dictionaryRepresentation = [self.dataStore.dictionaryRepresentationUnit bodyWithDocument:self.document];
    NSString *description = [self.dataStore.descriptionUnit bodyWithDocument:self.document];
    NSString *copying = [self.dataStore.copyingUnit bodyWithDocument:self.document];
    NSString *coding = [self.dataStore.codingUnit bodyWithDocument:self.document];
    
    return M_CONTENT(header, className, defines, synthesizes, dealloc, setAttributesWithDictionary, initWithDictionary, objectWithDictionary, objectsWithArray, dictionaryRepresentation, description, copying, coding);
}

@end
