//
//  NewOutlineEntity.h
//  Wheel
//
//  Created by Alexander on 17.01.13.
//
//

#import <Foundation/Foundation.h>

@interface OutlineEntity : NSObject

@property (strong) NSString *name;
@property (strong) NSArray *children;

+ (NSTreeNode *)rootNode;

@end
