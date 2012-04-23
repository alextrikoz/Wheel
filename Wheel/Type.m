//
//  Type.m
//  Wheel
//
//  Created by Alexander on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Type.h"

@implementation Type

@dynamic checked;
@dynamic name;

- (id)copyWithZone:(NSZone *)zone {
    Type *object = [[[self class] allocWithZone:zone] init];
    
    object.checked = self.checked;
    object.name = self.name;
    
    return object;
}

@end
