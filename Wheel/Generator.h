//
//  Generator.h
//  Wheel
//
//  Created by Alexander on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Document;

@interface Generator : NSObject

@property (strong) Document *document;

- (NSString *)h_content;
- (NSString *)m_content;

@end
