//
//  DataStore.m
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"

#import "Entity.h"
#import "ManagedUnit.h"
#import "AppDelegate.h"

enum {
    IVARS_UNIT_NUMBER,
    SYNTHESIZES_UNIT_NUMBER,
    DEALLOC_UNIT_NUMBER,
    INSTANCE_UNIT_NUMBER,
    SETATTRIBUTESWITHDICTIONARY_UNIT_NUMBER,
    INITWITHDICTIONARY_UNIT_NUMBER,
    OBJECTWITHDICTIONARY_UNIT_NUMBER,
    OBJECTSWITHARRAY_UNIT_NUMBER,
    DICTIONARYREPRESENTATION_UNIT_NUMBER,
    DESCRIPTION_UNIT_NUMBER,
    COPYING_UNIT_NUMBER,
    CODING_UNIT_NUMBER,
    ARC_UNIT_NUMBER,
    MODERNSYNTAX_UNIT_NUMBER
};

@implementation DataStore

@synthesize units = _units;
- (NSArray *)units {
    NSManagedObjectContext *managedObjectContext = ((AppDelegate *)NSApplication.sharedApplication.delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ManagedUnit"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
    return [managedObjectContext executeFetchRequest:request error:nil];
}
- (void)setUnits:(NSArray *)units {}

static DataStore *_sharedDataStore = nil;

+ (DataStore *)sharedDataStore {
    if(_sharedDataStore == nil) {
        _sharedDataStore = [self new];
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
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"plist"]];
    
    self.setters = dictionary[@"setters"];
    self.setters = self.setters;
    
    self.atomicities = dictionary[@"atomicities"];
    self.atomicities = self.atomicities;
    
    self.writabilities = dictionary[@"writabilities"];
    self.writabilities = self.writabilities;
    
    self.kinds = dictionary[@"kinds"];
    self.kinds = self.kinds;
    
    NSManagedObjectContext *managedObjectContext = ((AppDelegate *)NSApplication.sharedApplication.delegate).managedObjectContext;
    self.units = self.units;
    if (!self.units.count) {
        for (NSDictionary *unitInfo in dictionary[@"units"]) {
            [ManagedUnit managedUnitWithDictionary:unitInfo managedObjectContext:managedObjectContext];
        }
        [managedObjectContext save:nil];
        self.units = self.units;
    }
    
    self.types = dictionary[@"types"];
    self.types = self.types;
    
    [self loadUnits];
}

- (void)loadUnits {    
    self.HContentUnit = [HContentUnit new];
    
    self.MContentUnit = [MContentUnit new];
    
    self.headerUnit = [HeaderUnit new];
    
    self.importUnit = [ImportUnit new];
    
    self.protocolsUnit = [ProtocolsUnit new];
    
    self.iVarsUnit = [IVarsUnit new];
    self.iVarsUnit.managedUnit = self.units[IVARS_UNIT_NUMBER];
    
    self.propertiesUnit = [PropertiesUnit new];
    
    self.prototypesUnit = [PrototypesUnit new];
    
    self.definesUnit = [DefinesUnit new];
    
    self.synthesizesUnit = [SynthesizesUnit new];
    self.synthesizesUnit.managedUnit = self.units[SYNTHESIZES_UNIT_NUMBER];
    
    self.deallocUnit = [DeallocUnit new];
    self.deallocUnit.managedUnit = self.units[DEALLOC_UNIT_NUMBER];
    
    self.instanceUnit = [InstanceUnit new];
    self.instanceUnit.managedUnit = self.units[INSTANCE_UNIT_NUMBER];
    
    self.setAttributesWithDictionaryUnit = [SetAttributesWithDictionaryUnit new];
    self.setAttributesWithDictionaryUnit.managedUnit = self.units[SETATTRIBUTESWITHDICTIONARY_UNIT_NUMBER];
    
    self.initWithDictionaryUnit = [InitWithDictionaryUnit new];
    [self.initWithDictionaryUnit setManagedUnit:self.units[INITWITHDICTIONARY_UNIT_NUMBER]];
    
    self.objectWithDictionaryUnit = [ObjectWithDictionaryUnit new];
    self.objectWithDictionaryUnit.managedUnit = self.units[OBJECTWITHDICTIONARY_UNIT_NUMBER];
    
    self.objectsWithArrayUnit = [ObjectsWithArrayUnit new];
    self.objectsWithArrayUnit.managedUnit = self.units[OBJECTSWITHARRAY_UNIT_NUMBER];
    
    self.dictionaryRepresentationUnit = [DictionaryRepresentationUnit new];
    self.dictionaryRepresentationUnit.managedUnit = self.units[DICTIONARYREPRESENTATION_UNIT_NUMBER];
    
    self.descriptionUnit = [DescriptionUnit new];
    self.descriptionUnit.managedUnit = self.units[DESCRIPTION_UNIT_NUMBER];
    
    self.copyingUnit = [NSCopyingUnit new];
    self.copyingUnit.managedUnit = self.units[COPYING_UNIT_NUMBER];
    
    self.codingUnit = [NSCodingUnit new];
    self.codingUnit.managedUnit = self.units[CODING_UNIT_NUMBER];
    
    self.ARCUnit = [ARCUnit new];
    self.ARCUnit.managedUnit = self.units[ARC_UNIT_NUMBER];
    
    self.modernSyntaxUnit = [ModernSyntaxUnit new];
    self.modernSyntaxUnit.managedUnit = self.units[MODERNSYNTAX_UNIT_NUMBER];
    
    [self.setAttributesWithDictionaryUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [[self.initWithDictionaryUnit managedUnit] addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.objectWithDictionaryUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.ARCUnit.managedUnit addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[ManagedUnit class]]) {
        NSManagedObjectContext *managedObjectContext = ((AppDelegate *)NSApplication.sharedApplication.delegate).managedObjectContext;
        self.deallocUnit.managedUnit.enabled = @(!self.ARCUnit.managedUnit.on.boolValue);
        [self.initWithDictionaryUnit managedUnit].enabled = @(self.setAttributesWithDictionaryUnit.available);
        [self.objectWithDictionaryUnit managedUnit].enabled = @([self.initWithDictionaryUnit available]);
        self.objectsWithArrayUnit.managedUnit.enabled = @(self.objectWithDictionaryUnit.available);
        [managedObjectContext save:nil];
        self.units = self.units;
    }
}

@end
