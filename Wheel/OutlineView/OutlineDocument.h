//
//  OutlineDocument.h
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import <Cocoa/Cocoa.h>

@class Entity;

@interface OutlineDocument : NSDocument

@property NSString *className;
@property NSString *superClassName;
@property NSTreeNode *rootNode;
@property NSMutableArray *models;

- (void)backupRootNode;

- (void)updateModels;

+ (void)showWithEntity:(Entity *)entity;

@end
