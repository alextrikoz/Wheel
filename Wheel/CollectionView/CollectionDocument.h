//
//  CollectionDocument.h
//  Wheel
//
//  Created by Alexander on 13.02.13.
//
//

#import <Cocoa/Cocoa.h>

@class Entity;

@interface CollectionDocument : NSDocument

@property Entity *rootEntity;
@property NSMutableArray *models;

@end
