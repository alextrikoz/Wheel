//
//  OutlineDocument.h
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import <Cocoa/Cocoa.h>

@interface OutlineDocument : NSDocument

@property (strong) NSString *className;
@property (strong) NSString *superClassName;

@property (strong) NSTreeNode *rootNode;

- (void)backupRootNode;
- (void)backupRootNodeWithDictionary:(NSDictionary *)dictionary;

@end
