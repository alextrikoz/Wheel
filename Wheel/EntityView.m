//
//  EntityView.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityView.h"

#import "Entity.h"

@implementation EntityView

- (IBAction)remove:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeEntity" object:self.representedObject];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    CALayer *layer = [[CALayer alloc] init];
    [self.view setWantsLayer:YES];
    if (selected) {
        [layer setBackgroundColor:CGColorCreateGenericRGB(0.0, 0.0, 1.0, 1.0)];
    } else {
        [layer setBackgroundColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)];
    }
    [self.view setLayer:layer];
}

@end
