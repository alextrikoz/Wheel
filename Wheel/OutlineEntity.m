//
//  OutlineEntity.m
//  Wheel
//
//  Created by Alexander on 17.09.12.
//
//

#import "OutlineEntity.h"

@implementation OutlineEntity

- (id)init {
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.children forKey:@"children"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.children = [decoder decodeObjectForKey:@"children"];
    }
    return self;
}

@end
