//
//  Type.m
//  Wheel
//
//  Created by Alexander on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Type.h"

@implementation Type

@dynamic name;

+ (Type *)typeWithName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Type *type = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:managedObjectContext];
    type.name = name;
    return type;
}

@end
