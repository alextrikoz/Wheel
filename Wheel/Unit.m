//
//  Method.m
//  Wheel
//
//  Created by Alexander on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Unit.h"
#import "Entity.h"
#import "Document.h"
#import "Config.h"

@implementation Unit

@synthesize name;
@synthesize visible;
@synthesize enable;
@synthesize on;

- (BOOL)available {
    return self.enable.boolValue && self.on.boolValue;
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
    if (!document.entities.count) {
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
- (NSString *)bodyWithDocument:(Document *)document  {
    return self.available ? M_INITWITHDICTIONARY(document.className) : @"";
}
@end

@implementation ObjectWithDictionaryUnit
- (NSString *)bodyWithDocument:(Document *)document {
    return self.available ? M_OBJECTWITHDICTIONARY_MRR(document.className) : @"";
}
@end

@implementation ObjectsWithArrayUnit
- (NSString *)bodyWithDocument:(Document *)document {
    return self.available ? M_OBJECTSWITHARRAY : @"";
}
@end

@implementation DictionaryRepresentationUnit
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
