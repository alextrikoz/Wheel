//
//  Type.h
//  Wheel
//
//  Created by Alexander on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Type : NSManagedObject

@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) NSString * name;

@end
