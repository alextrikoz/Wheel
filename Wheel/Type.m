//
//  Type.m
//  Wheel
//
//  Created by Alexander on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Type.h"

@implementation Type

@synthesize name = _name;

- (id)copyWithZone:(NSZone *)zone {
    Type *object = [[[self class] allocWithZone:zone] init];
    
    object.name = self.name;
    
    return object;
}

@end
