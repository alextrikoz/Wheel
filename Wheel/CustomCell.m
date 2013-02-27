//
//  ImageAndTextCell.m
//  Wheel
//
//  Created by Alexander on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawWithFrame:cellFrame inView:controlView];
    
    if (!self.regex || !self.isEnabled) {
        return;
    }
    
    NSRange range1 = NSMakeRange(0, self.stringValue.length);
    NSRange range2 = [self.regex rangeOfFirstMatchInString:self.stringValue options:0 range:range1];
    if(NSEqualRanges(range1, range2)) {
        return;
    }
    
    NSImage *image = [NSImage imageNamed:@"alert.png"];
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    NSRect inRect = cellFrame;
    inRect.origin.x += [self.stringValue sizeWithAttributes:attributes].width;
    inRect.size.width = cellFrame.size.height;
    NSRect fromRect = NSZeroRect;
    fromRect.size = image.size;
    [image drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1.0];
}

@end

@implementation VarTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.regex = [[NSRegularExpression alloc] initWithPattern:@"^[a-z_][a-z0-9_]*[ ]*[*]*[ ]*$" options:NSRegularExpressionCaseInsensitive error:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        self.regex = [[NSRegularExpression alloc] initWithPattern:@"^[a-z_][a-z0-9_]*[ ]*[*]*[ ]*$" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    return self;
}

@end

@implementation VarNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.regex = [[NSRegularExpression alloc] initWithPattern:@"^[a-z_][a-z0-9_]*$" options:NSRegularExpressionCaseInsensitive error:nil];
}

@end