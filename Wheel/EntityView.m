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

@end
