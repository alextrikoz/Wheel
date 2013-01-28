//
//  NewOutlineEntity.m
//  Wheel
//
//  Created by Alexander on 17.01.13.
//
//

#import "OutlineEntity.h"

@implementation OutlineEntity

+ (OutlineEntity *)objectWithDictionary:(NSDictionary *)dictionary {
    OutlineEntity *outlineEntity = [OutlineEntity new];
    outlineEntity.name = dictionary[@"Name"];
    outlineEntity.children = [self objectsWithArray:dictionary[@"Children"]];
    return outlineEntity;
}

+ (NSMutableArray *)objectsWithArray:(NSArray *)array {
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [nodes addObject:[OutlineEntity objectWithDictionary:dictionary]];
    }
    return nodes;
}

+ (OutlineEntity *)rootEntity {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OutlineConfig" ofType:@"plist"]];
    return [self objectWithDictionary:dictionary];
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeString];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return self.name;
}

@end
