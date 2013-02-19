//
//  Document.h
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class Entity;

@interface TableDocument : NSDocument

@property (strong) NSString *className;
@property (strong) NSString *superClassName;
@property Entity *rootEntity;

- (void)backupRootEntity;

@end
