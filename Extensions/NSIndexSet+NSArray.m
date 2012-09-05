//
//  NSIndexSet+NSArray.m
//  Wheel
//
//  Created by Alexander on 05.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSIndexSet+NSArray.h"

@implementation NSIndexSet (NSArray)

- (NSArray *)array {
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger index = [self firstIndex];
    while(index != NSNotFound) {
        [array addObject:[NSNumber numberWithInteger:index]];
        index = [self indexGreaterThanIndex:index];
    }
    return array;
}

@end
