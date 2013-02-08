//
//  ManagedUnit.m
//  Wheel
//
//  Created by Alexander on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagedUnit.h"

#import "Entity.h"
#import "DataStore.h"
#import "Document.h"
#import "Config.h"

@implementation ManagedUnit

@dynamic enable;
@dynamic name;
@dynamic number;
@dynamic on;

- (BOOL)available {
    return self.enable.boolValue && self.on.boolValue;
}

@end

@implementation Unit

@synthesize managedUnit = _managedUnit;

- (BOOL)available {
    return self.managedUnit.available;
}

@end

@implementation HContentUnit

- (NSString *)bodyWithDocument:(Document *)document pathExtension:(NSString *)pathExtension {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *header = [dataStore.headerUnit bodyWithDocument:document pathExtension:@"h"];
    NSString *imoprts = [dataStore.importUnit prototypeWithDocument:document];
    NSString *className = document.className;
    NSString *superClassName = document.superClassName;
    NSString *protocols = [dataStore.protocolsUnit bodyWithDocument:document];
    NSString *iVars = [dataStore.iVarsUnit bodyWithDocument:document];
    NSString *properties = [dataStore.propertiesUnit bodyWithDocument:document];
    NSString *prototypes = [dataStore.prototypesUnit bodyWithDocument:document];
    
    return H_CONTENT(header, imoprts, className, superClassName, protocols, iVars, properties, prototypes);
}

@end

@implementation MContentUnit

- (NSString *)bodyWithDocument:(Document *)document pathExtension:(NSString *)pathExtension {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *header = [dataStore.headerUnit bodyWithDocument:document pathExtension:@"m"];
    NSString *imoprts = [dataStore.importUnit bodyWithDocument:document];
    NSString *className = document.className;
    NSString *defines = [dataStore.definesUnit bodyWithDocument:document];
    NSString *synthesizes = [dataStore.synthesizesUnit bodyWithDocument:document];
    NSString *dealloc = [dataStore.deallocUnit bodyWithDocument:document];
    NSString *setAttributesWithDictionary = [dataStore.setAttributesWithDictionaryUnit bodyWithDocument:document];
    NSString *initWithDictionary = [dataStore.initWithDictionaryUnit bodyWithDocument:document];
    NSString *objectWithDictionary = [dataStore.objectWithDictionaryUnit bodyWithDocument:document];
    NSString *objectsWithArray = [dataStore.objectsWithArrayUnit bodyWithDocument:document];
    NSString *dictionaryRepresentation = [dataStore.dictionaryRepresentationUnit bodyWithDocument:document];
    NSString *description = [dataStore.descriptionUnit bodyWithDocument:document];
    NSString *copying = [dataStore.copyingUnit bodyWithDocument:document];
    NSString *coding = [dataStore.codingUnit bodyWithDocument:document];
    
    return M_CONTENT(header, className, imoprts, defines, synthesizes, dealloc, setAttributesWithDictionary, initWithDictionary, objectWithDictionary, objectsWithArray, dictionaryRepresentation, description, copying, coding);
}

@end

@implementation HeaderUnit

- (NSString *)bodyWithDocument:(Document *)document pathExtension:(NSString *)pathExtension {
    id defaultValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *fileName = [document.className stringByAppendingPathExtension:pathExtension];
    NSString *myProjectName = [defaultValues valueForKey:@"MyProjectName"];
    NSString *myName = [defaultValues valueForKey:@"MyName"];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *createdDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *copyrightDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *myCompanyName = [defaultValues valueForKey:@"MyCompanyName"];
    
    return HEADER(fileName, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
}

@end

@implementation ImportUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    if (!document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity h_importStuff]];
    }
    if (stuff.length) {
        stuff = [stuff stringByAppendingString:@"\n"];
    }
    return stuff;
}

- (NSString *)bodyWithDocument:(Document *)document {
    if (!document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_importStuff]];
    }
    if (stuff.length) {
        stuff = [stuff stringByAppendingString:@"\n"];
    }
    return stuff;
}

@end

@implementation ProtocolsUnit

- (NSString *)bodyWithDocument:(Document *)document {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    if (dataStore.copyingUnit.available && dataStore.codingUnit.available) {
        return @"<NSCopying, NSCoding>";
    } else if (dataStore.copyingUnit.available) {
        return @"<NSCopying>";
    } else if (dataStore.codingUnit.available) {
        return @"<NSCoding>";
    } else {
        return @"";
    }
}

@end

@implementation IVarsUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available || !document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity h_iVarStuff]];
    }
    return H_IVARS(stuff);
}

@end

@implementation PropertiesUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity h_propertyStuff]];
    }
    return H_PROPERTIES(stuff);
}

@end

@implementation PrototypesUnit

- (NSString *)bodyWithDocument:(Document *)document {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *setAttributesWithDictionaryPrototype = [dataStore.setAttributesWithDictionaryUnit prototypeWithDocument:document];
    NSString *initWithDictionaryPrototype = [dataStore.initWithDictionaryUnit prototypeWithDocument:document];
    NSString *objectWithDictionaryPrototype = [dataStore.objectWithDictionaryUnit prototypeWithDocument:document];
    NSString *objectsWithArrayPrototype = [dataStore.objectsWithArrayUnit prototypeWithDocument:document];
    NSString *dictionaryRepresentationPrototype = [dataStore.dictionaryRepresentationUnit prototypeWithDocument:document];
    NSString *descriptionPrototype = [dataStore.descriptionUnit prototypeWithDocument:document];
    
    if (setAttributesWithDictionaryPrototype.length ||
        initWithDictionaryPrototype.length ||
        objectsWithArrayPrototype.length ||
        objectsWithArrayPrototype.length ||
        dictionaryRepresentationPrototype.length ||
        descriptionPrototype.length) {
        return H_PROTOTYPES(setAttributesWithDictionaryPrototype, initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype, dictionaryRepresentationPrototype, descriptionPrototype);
    } else {
        return @"";
    }
}

@end

@implementation DefinesUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_defineStuff]];
    }
    return M_DEFINES(stuff);
}

@end

@implementation SynthesizesUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available || !document.entities.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

@end

@implementation DeallocUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

@end

@implementation SetAttributesWithDictionaryUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_SETATTRIBUTESWITHDICTIONARY_PROTOTYPE : @"";
}

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_setAttributesWithDictionaryStuff]];
    }
    return M_SETATTRIBUTESWITHDICTIONARY(stuff);
}

@end

@implementation InitWithDictionaryUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_INITWITHDICTIONARY_PROTOTYPE(document.className) : @"";
}

- (NSString *)bodyWithDocument:(Document *)document  {
    return self.available ? M_INITWITHDICTIONARY(document.className) : @"";
}

@end

@implementation ObjectWithDictionaryUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_OBJECTWITHDICTIONARY_PROTOTYPE(document.className) : @"";
}

- (NSString *)bodyWithDocument:(Document *)document {
    DataStore *dataStore = DataStore.sharedDataStore;
    ARCUnit *ARCUnit = dataStore.ARCUnit;    
    return self.available ? ARCUnit.available ?  M_OBJECTWITHDICTIONARY_ARC(document.className) : M_OBJECTWITHDICTIONARY_MRR(document.className) : @"";
}

@end

@implementation ObjectsWithArrayUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
}

- (NSString *)bodyWithDocument:(Document *)document {
    return self.available ? M_OBJECTSWITHARRAY : @"";
}

@end

@implementation DictionaryRepresentationUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_DICTIONARYREPRESENTATION_PROTOTYPE : @"";
}

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_dictionaryRepresentationStuff]];
    }
    return M_DICTIONARYREPRESENTATION(stuff);
}

@end

@implementation DescriptionUnit

- (NSString *)prototypeWithDocument:(Document *)document {
    return self.available ? H_DESCRIPTION_PROTOTYPE : @"";
}

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_descriptionStuff]];
    }
    return M_DESCRIPTION(stuff);
}

@end

@implementation NSCopyingUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *entity in document.entities) {
        stuff = [stuff stringByAppendingString:[entity m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(document.className, stuff);
}

@end

@implementation NSCodingUnit

- (NSString *)bodyWithDocument:(Document *)document {
    if (!self.available) {
        return @"";
    }
    NSString *initWithCoderStuff = @"";
    NSString *encodeWithCoderStuff = @"";
    for (Entity *entity in document.entities) {
        initWithCoderStuff = [initWithCoderStuff stringByAppendingString:[entity m_initWithCoderStuff]];
        encodeWithCoderStuff = [encodeWithCoderStuff stringByAppendingString:[entity m_encodeWithCoderStuff]];
    }
    return [NSString stringWithFormat:@"%@%@", M_INITWITHCODER(initWithCoderStuff), M_ENCODEWITHCODER(encodeWithCoderStuff)];
}

@end

@implementation ARCUnit

@end
