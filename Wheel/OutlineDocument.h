//
//  OutlineDocument.h
//  Wheel
//
//  Created by Alexander on 16.09.12.
//
//

#import <Cocoa/Cocoa.h>

@interface OutlineDocument : NSDocument

@property (strong) NSMutableArray *entities;
@property (strong) NSMutableArray *selectedEntities;

- (void)addObject;
- (void)addModel;
- (void)addCollection;
- (void)removeSelectedEntities;

@end
