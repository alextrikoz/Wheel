//
//  ManagedUnit.m
//  Wheel
//
//  Created by Alexander on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagedUnit.h"

#import "Entity.h"
#import "Config.h"
#import "DataStore.h"

@implementation ManagedUnit

@dynamic enabled;
@dynamic name;
@dynamic number;
@dynamic on;

+ (ManagedUnit *)managedUnitWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    ManagedUnit *managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:managedObjectContext];
    managedUnit.enabled = @YES;
    managedUnit.name = dictionary[@"name"];
    managedUnit.number = dictionary[@"number"];
    managedUnit.on = dictionary[@"on"];
    return managedUnit;
}

- (BOOL)available {
    return self.enabled.boolValue && self.on.boolValue;
}

@end

@implementation Unit

- (BOOL)available {
    return self.managedUnit.available;
}

@end

@implementation HContentUnit

- (NSString *)bodyWithEntity:(Entity *)entity pathExtension:(NSString *)pathExtension {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *header = [dataStore.headerUnit bodyWithEntity:entity pathExtension:@"h"];
    NSString *imoprts = [dataStore.importUnit prototypeWithEntity:entity];
    NSString *className = entity.className;
    NSString *superClassName = entity.superClassName;
    NSString *protocols = [dataStore.protocolsUnit bodyWithEntity:entity];
    NSString *iVars = [dataStore.iVarsUnit bodyWithEntity:entity];
    NSString *properties = [dataStore.propertiesUnit bodyWithEntity:entity];
    NSString *prototypes = [dataStore.prototypesUnit bodyWithEntity:entity];
    
    return H_CONTENT(header, imoprts, className, superClassName, protocols, iVars, properties, prototypes);
}

@end

@implementation MContentUnit

- (NSString *)bodyWithEntity:(Entity *)entity pathExtension:(NSString *)pathExtension {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *header = [dataStore.headerUnit bodyWithEntity:entity pathExtension:@"m"];
    NSString *imoprts = [dataStore.importUnit bodyWithEntity:entity];
    NSString *className = entity.className;
    NSString *defines = [dataStore.definesUnit bodyWithEntity:entity];
    NSString *synthesizes = [dataStore.synthesizesUnit bodyWithEntity:entity];
    NSString *dealloc = [dataStore.deallocUnit bodyWithEntity:entity];
    NSString *setAttributesWithDictionary = [dataStore.setAttributesWithDictionaryUnit bodyWithEntity:entity];
    NSString *initWithDictionary = [dataStore.initWithDictionaryUnit bodyWithEntity:entity];
    NSString *objectWithDictionary = [dataStore.objectWithDictionaryUnit bodyWithEntity:entity];
    NSString *objectsWithArray = [dataStore.objectsWithArrayUnit bodyWithEntity:entity];
    NSString *dictionaryRepresentation = [dataStore.dictionaryRepresentationUnit bodyWithEntity:entity];
    NSString *description = [dataStore.descriptionUnit bodyWithEntity:entity];
    NSString *copying = [dataStore.copyingUnit bodyWithEntity:entity];
    NSString *coding = [dataStore.codingUnit bodyWithEntity:entity];
    
    return M_CONTENT(header, className, imoprts, defines, synthesizes, dealloc, setAttributesWithDictionary, initWithDictionary, objectWithDictionary, objectsWithArray, dictionaryRepresentation, description, copying, coding);
}

@end

@implementation HeaderUnit

- (NSString *)bodyWithEntity:(Entity *)entity pathExtension:(NSString *)pathExtension {
    id defaultValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *fileName = [entity.className stringByAppendingPathExtension:pathExtension];
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

- (NSString *)prototypeWithEntity:(Entity *)entity {
    if (!entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        if ([stuff rangeOfString:[child h_importStuff]].location == NSNotFound) {
            stuff = [stuff stringByAppendingString:[child h_importStuff]];            
        }
    }
    if (stuff.length) {
        stuff = [stuff stringByAppendingString:@"\n"];
    }
    return stuff;
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        if ([stuff rangeOfString:[child m_importStuff]].location == NSNotFound) {
            stuff = [stuff stringByAppendingString:[child m_importStuff]];
        }
    }
    if (stuff.length) {
        stuff = [stuff stringByAppendingString:@"\n"];
    }
    return stuff;
}

@end

@implementation ProtocolsUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
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

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available || !entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child h_iVarStuff]];
    }
    return H_IVARS(stuff);
}

@end

@implementation PropertiesUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child h_propertyStuff]];
    }
    return H_PROPERTIES(stuff);
}

@end

@implementation PrototypesUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    DataStore *dataStore = DataStore.sharedDataStore;
    
    NSString *setAttributesWithDictionaryPrototype = [dataStore.setAttributesWithDictionaryUnit prototypeWithEntity:entity];
    NSString *initWithDictionaryPrototype = [dataStore.initWithDictionaryUnit prototypeWithEntity:entity];
    NSString *objectWithDictionaryPrototype = [dataStore.objectWithDictionaryUnit prototypeWithEntity:entity];
    NSString *objectsWithArrayPrototype = [dataStore.objectsWithArrayUnit prototypeWithEntity:entity];
    NSString *dictionaryRepresentationPrototype = [dataStore.dictionaryRepresentationUnit prototypeWithEntity:entity];
    NSString *descriptionPrototype = [dataStore.descriptionUnit prototypeWithEntity:entity];
    
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

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_defineStuff]];
    }
    return M_DEFINES(stuff);
}

@end

@implementation SynthesizesUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available || !entity.children.count) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_synthesizeStuff]];
    }
    return M_SYNTHESIZES(stuff);
}

@end

@implementation DeallocUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_deallocStuff]];
    }
    return M_DEALLOC(stuff);
}

@end

@implementation SetAttributesWithDictionaryUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_SETATTRIBUTESWITHDICTIONARY_PROTOTYPE : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_setAttributesWithDictionaryStuff]];
    }
    return M_SETATTRIBUTESWITHDICTIONARY(stuff);
}

@end

@implementation InitWithDictionaryUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_INITWITHDICTIONARY_PROTOTYPE(entity.className) : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity  {
    return self.available ? M_INITWITHDICTIONARY(entity.className) : @"";
}

@end

@implementation ObjectWithDictionaryUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_OBJECTWITHDICTIONARY_PROTOTYPE(entity.className) : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    DataStore *dataStore = DataStore.sharedDataStore;
    ARCUnit *ARCUnit = dataStore.ARCUnit;    
    return self.available ? ARCUnit.available ?  M_OBJECTWITHDICTIONARY_ARC(entity.className) : M_OBJECTWITHDICTIONARY_MRR(entity.className) : @"";
}

@end

@implementation ObjectsWithArrayUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    return self.available ? M_OBJECTSWITHARRAY : @"";
}

@end

@implementation DictionaryRepresentationUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_DICTIONARYREPRESENTATION_PROTOTYPE : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_dictionaryRepresentationStuff]];
    }
    return M_DICTIONARYREPRESENTATION(stuff);
}

@end

@implementation DescriptionUnit

- (NSString *)prototypeWithEntity:(Entity *)entity {
    return self.available ? H_DESCRIPTION_PROTOTYPE : @"";
}

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_descriptionStuff]];
    }
    return M_DESCRIPTION(stuff);
}

@end

@implementation NSCopyingUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *stuff = @"";
    for (Entity *child in entity.children) {
        stuff = [stuff stringByAppendingString:[child m_copyWithZoneStuff]];
    }
    return M_COPYWITHZONE(entity.className, stuff);
}

@end

@implementation NSCodingUnit

- (NSString *)bodyWithEntity:(Entity *)entity {
    if (!self.available) {
        return @"";
    }
    NSString *initWithCoderStuff = @"";
    NSString *encodeWithCoderStuff = @"";
    for (Entity *child in entity.children) {
        initWithCoderStuff = [initWithCoderStuff stringByAppendingString:[child m_initWithCoderStuff]];
        encodeWithCoderStuff = [encodeWithCoderStuff stringByAppendingString:[child m_encodeWithCoderStuff]];
    }
    return [NSString stringWithFormat:@"%@%@", M_INITWITHCODER(initWithCoderStuff), M_ENCODEWITHCODER(encodeWithCoderStuff)];
}

@end

@implementation ARCUnit

@end

@implementation ModernSyntaxUnit

@end
