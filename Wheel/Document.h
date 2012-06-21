//
//  Document.h
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface Document : NSDocument

@property (copy) NSString *className;
@property (copy) NSString *superClassName;
@property (strong) NSMutableArray *entities;
@property (strong) NSIndexSet *selectedEntities;

- (NSMutableArray *)defaultEnities;
- (void)addEntity;
- (void)removeSelectedEntities;

@end
