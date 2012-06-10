//
//  Option.m
//  Wheel
//
//  Created by Alexander on 26.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Option.h"

@implementation Option

@dynamic active;
@dynamic enabled;
@dynamic name;
@dynamic order;

- (void)setEnabled:(NSNumber *)enabled {
    _enabled = enabled;
    
    if ([self.name isEqualToString:@"ARC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ARCPropertyChanged" object:self];
    }
}

@end
