//
//  NSString+English.m
//  Wheel
//
//  Created by Alexander on 20.02.13.
//
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (NSString *)varName {
    NSString *regEx = @"[A-Za-z1-9_]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    NSMutableString *varName = [NSMutableString string];
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i,1)];
        if ([predicate evaluateWithObject:character]) {
            if (varName.length == 0) {
                NSString *regEx = @"[1-9]";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
                if ([predicate evaluateWithObject:character]) {
                    character = @"_";
                }
                character = character.lowercaseString;
            }
        } else {
            character = @"_";
        }
        [varName appendString:character];
    }
    return varName;
}

- (NSString *)typeName {
    return [self.varName.capitalizedString stringByAppendingString:@" *"];
}

@end
