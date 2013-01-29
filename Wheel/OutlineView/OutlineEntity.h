//
//  NewOutlineEntity.h
//  Wheel
//
//  Created by Alexander on 17.01.13.
//
//

#import <Foundation/Foundation.h>

@interface OutlineEntity : NSObject <NSCoding, NSPasteboardWriting>

@property (strong) NSString *name;
@property (strong) NSMutableArray *children;

+ (OutlineEntity *)objectWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)objectsWithArray:(NSArray *)array;
- (NSDictionary *)dictionaryRepresentation;

+ (OutlineEntity *)rootEntity;

@end
