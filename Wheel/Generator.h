//
//  Generator.h
//  Wheel
//
//  Created by Alexander on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Generator : NSObject

@property (strong) NSArray *entities;
@property (strong) NSString *className;
@property (strong) NSString *superClassName;

- (NSString *)h_content;
- (NSString *)m_content;

@end
