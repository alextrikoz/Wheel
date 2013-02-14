//
//  Document.h
//  Wheel
//
//  Created by Alexander on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface TableDocument : NSDocument

@property (strong) NSString *className;
@property (strong) NSString *superClassName;
@property (strong) NSMutableArray *entities;

@end
