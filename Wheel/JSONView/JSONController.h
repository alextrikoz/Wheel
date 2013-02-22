//
//  JSONController.h
//  Wheel
//
//  Created by Alexander on 10.02.13.
//
//

#import <Cocoa/Cocoa.h>

@class Entity;

@interface JSONController : NSWindowController

+ (Entity *)entityWithCollection:(id)object;

@end
