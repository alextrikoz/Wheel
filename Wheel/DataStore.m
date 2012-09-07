//
//  DataStore.m
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"

#import "Type.h"
#import "Entity.h"
#import "ManagedUnit.h"
#import "AppDelegate.h"

enum {
    SYNTHESIZES_UNIT_NUMBER,
    DEALLOC_UNIT_NUMBER,
    SETATTRIBUTESWITHDICTIONARY_UNIT_NUMBER,
    INITWITHDICTIONARY_UNIT_NUMBER,
    OBJECTWITHDICTIONARY_UNIT_NUMBER,
    OBJECTSWITHARRAY_UNIT_NUMBER,
    DICTIONARYREPRESENTATION_UNIT_NUMBER,
    DESCRIPTION_UNIT_NUMBER,
    COPYING_UNIT_NUMBER,
    CODING_UNIT_NUMBER,
    ARC_UNIT_NUMBER,
};

@implementation DataStore

@synthesize setters = _setters;
@synthesize atomicities = _atomicities;
@synthesize writabilities = _writabilities;
@synthesize types = _types;
- (NSArray *)types {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    return [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
}
- (void)setTypes:(NSArray *)types {}
@synthesize selectedTypes = _selectedTypes;
@synthesize units = _units;
- (NSArray *)units {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ManagedUnit"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
    return [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
}
- (void)setUnits:(NSArray *)units {}

@synthesize HContentUnit = _HContentUnit;
@synthesize MContentUnit = _MContentUnit;
@synthesize headerUnit = _headerUnit;
@synthesize protocolsUnit = _protocolsUnit;
@synthesize propertiesUnit = _propertiesUnit;
@synthesize prototypesUnit = _prototypesUnit;
@synthesize definesUnit = _definesUnit;
@synthesize synthesizesUnit = _synthesizesUnit;
@synthesize deallocUnit = _deallocUnit;
@synthesize setAttributesWithDictionaryUnit = _setAttributesWithDictionaryUnit;
@synthesize initWithDictionaryUnit = _initWithDictionaryUnit;
@synthesize objectWithDictionaryUnit = _objectWithDictionaryUnit;
@synthesize objectsWithArrayUnit = _objectsWithArrayUnit;
@synthesize dictionaryRepresentationUnit = _dictionaryRepresentationUnit;
@synthesize descriptionUnit = _descriptionUnit;
@synthesize copyingUnit = _copyingUnit;
@synthesize codingUnit = _codingUnit;
@synthesize ARCUnit = _ARCUnit;

static DataStore *_sharedDataStore = nil;

+ (DataStore *)sharedDataStore {
    if(_sharedDataStore == nil) {
        _sharedDataStore = [[self alloc] init];
    }
    return _sharedDataStore;
}

- (id)init {
    if (_sharedDataStore == nil) {
        _sharedDataStore = [super init];
    }
    return _sharedDataStore;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadTypes];
    [self loadSetters];
    [self loadAtomicities];
    [self loadWritabilities];
    [self loadUnits];
}

- (void)loadTypes {
    self.types = self.types;
    if (!self.types.count) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSArray *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSDate *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSDictionary *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSNumber *";
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
        type.name = @"NSString *";
        
        [appDelegate.managedObjectContext save:nil];
        
        self.types = self.types;
    }
}

- (void)loadSetters {
    self.setters = [NSMutableArray array];
    [self.setters addObject:@"assign"];
    [self.setters addObject:@"copy"];
    [self.setters addObject:@"retain"];
    [self.setters addObject:@"strong"];
    [self.setters addObject:@"unsafe_unretained"];
    [self.setters addObject:@"week"];
    self.setters = self.setters;
}

- (void)loadAtomicities {
    self.atomicities = [NSMutableArray array];
    [self.atomicities addObject:@"atomic"];
    [self.atomicities addObject:@"nonatomic"];
    self.atomicities = self.atomicities;
}

- (void)loadWritabilities {
    self.writabilities = [NSMutableArray array];
    [self.writabilities addObject:@"readonly"];
    [self.writabilities addObject:@"readwrite"];
    self.writabilities = self.writabilities;
}

- (void)loadUnits {
    self.units = self.units;
    if (!self.units.count) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        ManagedUnit *managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"@synthesize";
        managedUnit.number = [NSNumber numberWithInt:SYNTHESIZES_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (void)dealloc;";
        managedUnit.number = [NSNumber numberWithInt:DEALLOC_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (id)setAttributesWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:SETATTRIBUTESWITHDICTIONARY_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (id)initWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:INITWITHDICTIONARY_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"+ (id)objectWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:OBJECTWITHDICTIONARY_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"+ (NSArray *)objectsWithArray:(NSArray *)array;";
        managedUnit.number = [NSNumber numberWithInt:OBJECTSWITHARRAY_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (NSDictionary *)dictionaryRepresentation;";
        managedUnit.number = [NSNumber numberWithInt:DICTIONARYREPRESENTATION_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (NSString *)description;";
        managedUnit.number = [NSNumber numberWithInt:DESCRIPTION_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"NSCopying";
        managedUnit.number = [NSNumber numberWithInt:COPYING_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"NSCoding";
        managedUnit.number = [NSNumber numberWithInt:CODING_UNIT_NUMBER];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:NO];
        managedUnit.name = @"ARC";
        managedUnit.number = [NSNumber numberWithInt:ARC_UNIT_NUMBER];
        
        [appDelegate.managedObjectContext save:nil];
        
        self.units = self.units;
    }
    
    self.HContentUnit = [[HContentUnit alloc] init];
    
    self.MContentUnit = [[MContentUnit alloc] init];
    
    self.headerUnit = [[HeaderUnit alloc] init];
    
    self.protocolsUnit = [[ProtocolsUnit alloc] init];
    
    self.propertiesUnit = [[PropertiesUnit alloc] init];
    
    self.prototypesUnit = [[PrototypesUnit alloc] init];
    
    self.definesUnit = [[DefinesUnit alloc] init];
    
    self.synthesizesUnit = [[SynthesizesUnit alloc] init];
    self.synthesizesUnit.managedUnit = [self.units objectAtIndex:SYNTHESIZES_UNIT_NUMBER];
    
    self.deallocUnit = [[DeallocUnit alloc] init];
    self.deallocUnit.managedUnit = [self.units objectAtIndex:DEALLOC_UNIT_NUMBER];
    
    self.setAttributesWithDictionaryUnit = [[SetAttributesWithDictionaryUnit alloc] init];
    self.setAttributesWithDictionaryUnit.managedUnit = [self.units objectAtIndex:SETATTRIBUTESWITHDICTIONARY_UNIT_NUMBER];
    
    self.initWithDictionaryUnit = [[InitWithDictionaryUnit alloc] init];
    [self.initWithDictionaryUnit setManagedUnit:[self.units objectAtIndex:INITWITHDICTIONARY_UNIT_NUMBER]];
    
    self.objectWithDictionaryUnit = [[ObjectWithDictionaryUnit alloc] init];
    self.objectWithDictionaryUnit.managedUnit = [self.units objectAtIndex:OBJECTWITHDICTIONARY_UNIT_NUMBER];
    
    self.objectsWithArrayUnit = [[ObjectsWithArrayUnit alloc] init];
    self.objectsWithArrayUnit.managedUnit = [self.units objectAtIndex:OBJECTSWITHARRAY_UNIT_NUMBER];
    
    self.dictionaryRepresentationUnit = [[DictionaryRepresentationUnit alloc] init];
    self.dictionaryRepresentationUnit.managedUnit = [self.units objectAtIndex:DICTIONARYREPRESENTATION_UNIT_NUMBER];
    
    self.descriptionUnit = [[DescriptionUnit alloc] init];
    self.descriptionUnit.managedUnit = [self.units objectAtIndex:DESCRIPTION_UNIT_NUMBER];
    
    self.copyingUnit = [[NSCopyingUnit alloc] init];
    self.copyingUnit.managedUnit = [self.units objectAtIndex:COPYING_UNIT_NUMBER];
    
    self.codingUnit = [[NSCodingUnit alloc] init];
    self.codingUnit.managedUnit = [self.units objectAtIndex:CODING_UNIT_NUMBER];
    
    self.ARCUnit = [[ARCUnit alloc] init];
    self.ARCUnit.managedUnit = [self.units objectAtIndex:ARC_UNIT_NUMBER];
    
    [self.setAttributesWithDictionaryUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [[self.initWithDictionaryUnit managedUnit] addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.objectWithDictionaryUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.ARCUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[ManagedUnit class]]) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        self.deallocUnit.managedUnit.enable = [NSNumber numberWithBool:!self.ARCUnit.managedUnit.on.boolValue];
        [self.initWithDictionaryUnit managedUnit].enable = [NSNumber numberWithBool:self.setAttributesWithDictionaryUnit.available];
        [self.objectWithDictionaryUnit managedUnit].enable = [NSNumber numberWithBool:[self.initWithDictionaryUnit available]];
        self.objectsWithArrayUnit.managedUnit.enable = [NSNumber numberWithBool:self.objectWithDictionaryUnit.available];
        
        [appDelegate.managedObjectContext save:nil];
        
        self.units = self.units;
    }
}

- (void)addType {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:appDelegate.managedObjectContext];
    type.name = @"NSObject *";
    [appDelegate.managedObjectContext save:nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Type"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    self.types = self.types;
}

- (void)removeSelectedTypes {
    AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
    NSArray *selectedTypes = [self.types objectsAtIndexes:self.selectedTypes];
    for (Type *type in selectedTypes) {
        [appDelegate.managedObjectContext deleteObject:type];
    }
    [appDelegate.managedObjectContext save:nil];
    
    self.types = self.types;
}

@end
