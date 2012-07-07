//
//  ManagedUnit.h
//  Wheel
//
//  Created by Alexander on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedUnit : NSManagedObject

@property (nonatomic, retain) NSNumber * enable;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * on;

@end
