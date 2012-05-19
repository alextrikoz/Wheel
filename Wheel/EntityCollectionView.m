//
//  EntityView.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityCollectionView.h"

#import "Entity.h"

@implementation EntityCollectionView

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    CALayer *layer = [[CALayer alloc] init];
    [self.view setWantsLayer:YES];
    CGColorRef backgroundColor;
    if (selected) {
        backgroundColor = CGColorCreateGenericRGB(56.0/255.0, 117.0/255.0, 215.0/255.0, 1.0);
    } else {
        backgroundColor = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
    }
    layer.backgroundColor = backgroundColor;
    CGColorRelease(backgroundColor);
    self.view.layer = layer;
}

@end
