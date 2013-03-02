//
//  ImageAndTextCell.h
//  Wheel
//
//  Created by Alexander on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CustomCell : NSTextFieldCell

@property (strong, nonatomic) NSRegularExpression *regex;

@end

@interface VarTypeCell : CustomCell

@end

@interface VarNameCell : CustomCell

@end
