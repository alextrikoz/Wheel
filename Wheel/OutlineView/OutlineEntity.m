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

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.name forKey:@"Name"];
    
    NSMutableArray *childrenRepresentation = [NSMutableArray array];
    for (OutlineEntity *entity in self.children) {
        [childrenRepresentation addObject:entity.dictionaryRepresentation];
    }
    [dictionary setObject:childrenRepresentation forKey:@"Children"];
    
    return dictionary;
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
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.children forKey:@"children"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.children = [decoder decodeObjectForKey:@"children"];
    }
    return self;
}

@end
