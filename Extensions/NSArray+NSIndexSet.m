//
//  NSArray+NSIndexSet.m
//  Wheel
//
//  Created by Alexander on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+NSIndexSet.h"

@implementation NSArray (NSIndexSet)

- (NSIndexSet *)indexSet {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSNumber *index in self) {
        [indexSet addIndex:[index integerValue]];
    }
    return indexSet;
}

@end
