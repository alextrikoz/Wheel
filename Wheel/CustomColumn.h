//
//  CustomColumn.h
//  Wheel
//
//  Created by Alexander on 25.02.13.
//
//

#import <Cocoa/Cocoa.h>

typedef enum {
    TEXT_FIELD_CELL,
    POP_UP_BUTTON_CELL,
} DATA_CELL;

@class CustomColumn;

@protocol CustomColumnDelegate <NSObject>

- (DATA_CELL)customColumn:(CustomColumn *)customColumn dataCellForRow:(NSInteger)row;

@end

@interface CustomColumn : NSTableColumn

@property (weak) IBOutlet id delegate;

@end
