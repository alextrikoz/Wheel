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

- (id)init {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [super init];
    }
    return sharedInstance;
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
        managedUnit.name = @"- (void)dealloc;";
        managedUnit.number = [NSNumber numberWithInt:0];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (id)setAttributesWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:1];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (id)initWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:2];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"+ (id)objectWithDictionary:(NSDictionary *)dictionary;";
        managedUnit.number = [NSNumber numberWithInt:3];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"+ (NSArray *)objectsWithArray:(NSArray *)array;";
        managedUnit.number = [NSNumber numberWithInt:4];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (NSDictionary *)dictionaryRepresentation;";
        managedUnit.number = [NSNumber numberWithInt:5];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"- (NSString *)description;";
        managedUnit.number = [NSNumber numberWithInt:6];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"NSCopying";
        managedUnit.number = [NSNumber numberWithInt:7];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:YES];
        managedUnit.name = @"NSCoding";
        managedUnit.number = [NSNumber numberWithInt:8];
        
        managedUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ManagedUnit" inManagedObjectContext:appDelegate.managedObjectContext];
        managedUnit.enable = [NSNumber numberWithBool:YES];
        managedUnit.on = [NSNumber numberWithBool:NO];
        managedUnit.name = @"ARC";
        managedUnit.number = [NSNumber numberWithInt:9];
        
        [appDelegate.managedObjectContext save:nil];
        
        self.units = self.units;
    }
    
    self.HContentUnit = [[HContentUnit alloc] init];
    
    self.MContentUnit = [[MContentUnit alloc] init];
    
    self.headerUnit = [[HeaderUnit alloc] init];
    
    self.propertiesUnit = [[PropertiesUnit alloc] init];
    
    self.definesUnit = [[DefinesUnit alloc] init];
    
    self.synthesizesUnit = [[SynthesizesUnit alloc] init];
    
    self.deallocUnit = [[DeallocUnit alloc] init];
    self.deallocUnit.managedUnit = [self.units objectAtIndex:0];
    
    self.setAttributesWithDictionaryUnit = [[SetAttributesWithDictionaryUnit alloc] init];
    self.setAttributesWithDictionaryUnit.managedUnit = [self.units objectAtIndex:1];
    
    self.initWithDictionaryUnit = [[InitWithDictionaryUnit alloc] init];
    self.initWithDictionaryUnit.managedUnit = [self.units objectAtIndex:2];
    
    self.objectWithDictionaryUnit = [[ObjectWithDictionaryUnit alloc] init];
    self.objectWithDictionaryUnit.managedUnit = [self.units objectAtIndex:3];
    
    self.objectsWithArrayUnit = [[ObjectsWithArrayUnit alloc] init];
    self.objectsWithArrayUnit.managedUnit = [self.units objectAtIndex:4];
    
    self.dictionaryRepresentationUnit = [[DictionaryRepresentationUnit alloc] init];
    self.dictionaryRepresentationUnit.managedUnit = [self.units objectAtIndex:5];
    
    self.descriptionUnit = [[DescriptionUnit alloc] init];
    self.descriptionUnit.managedUnit = [self.units objectAtIndex:6];
    
    self.copyingUnit = [[NSCopyingUnit alloc] init];
    self.copyingUnit.managedUnit = [self.units objectAtIndex:7];
    
    self.codingUnit = [[NSCodingUnit alloc] init];
    self.codingUnit.managedUnit = [self.units objectAtIndex:8];
    
    self.ARCUnit = [[ARCUnit alloc] init];
    self.ARCUnit.managedUnit = [self.units objectAtIndex:9];
    
    [self.units addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:1] forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.units addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:2] forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.units addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:3] forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
    [self.units addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndex:9] forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[ManagedUnit class]]) {
        AppDelegate *appDelegate = NSApplication.sharedApplication.delegate;
        
        self.deallocUnit.managedUnit.enable = [NSNumber numberWithBool:!self.ARCUnit.managedUnit.on.boolValue];
        self.initWithDictionaryUnit.managedUnit.enable = [NSNumber numberWithBool:self.setAttributesWithDictionaryUnit.available];
        self.objectWithDictionaryUnit.managedUnit.enable = [NSNumber numberWithBool:self.initWithDictionaryUnit.available];
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
