//
//  NSString+Type.m
//  Wheel
//
//  Created by Alexander on 27.02.13.
//
//

#import "NSString+Type.h"

@implementation NSString (Type)

- (BOOL)isMutable {
    return [self rangeOfString:@"mutable" options:NSCaseInsensitiveSearch].location != NSNotFound;
}

@end
