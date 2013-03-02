//
//  CustomColumn.m
//  Wheel
//
//  Created by Alexander on 25.02.13.
//
//

#import "CustomColumn.h"

#import "CustomCell.h"

@implementation CustomColumn

- (id)dataCellForRow:(NSInteger)row {
    id dataCell = [super dataCell];
    
    if ([self.delegate respondsToSelector:@selector(customColumn:dataCellForRow:)]) {
        switch ([self.delegate customColumn:self dataCellForRow:row]) {
            case TEXT_FIELD_CELL: {
                VarTypeCell *textFieldCell = [VarTypeCell new];
                textFieldCell.editable = YES;
                return textFieldCell;
            }
            case POP_UP_BUTTON_CELL:
                return dataCell;
            default:
                return dataCell;
        }
    }
    return dataCell;
}

@end
