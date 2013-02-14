//
//  CustomView.m
//  Wheel
//
//  Created by Alexander on 14.02.13.
//
//

#import "CustomView.h"

@implementation CustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.imageFrameStyle = NSImageFrameNone;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.view.wantsLayer = YES;
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = (selected) ? CGColorCreateGenericRGB(56.0/255.0, 117.0/255.0, 215.0/255.0, 1.0) : CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
    self.view.layer = layer;
}

@end
