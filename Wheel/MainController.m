//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

#import <Carbon/Carbon.h>

#import "Config.h"

#import "Option.h"
#import "Entity.h"
#import "DataStore.h"
#import "Generator.h"

@implementation MainController

@synthesize className = _className;
@synthesize superClassName = _superClassName;
@synthesize entities = _entities;
@synthesize selectedEntities = _selectedEntities;
@synthesize dataStore = _dataStore;
@synthesize tableView = _tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.className = @"MyClass";
    self.superClassName = @"NSObject";
    
    if (!self.entities) {
        [self loadEntities];
    }
    
    [self.tableView deselectAll:nil];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.className;
}

- (void)loadEntities {
    self.entities = [NSMutableArray array];
    
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"title";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"copy";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSDate *";
    entity.name = @"date";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    
    self.entities = self.entities;
}

- (void)addEntity {
    Entity *entity = [[Entity alloc] init];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    self.entities = self.entities;
}

- (void)removeSelectedEntities {
    [self.entities removeObjectsAtIndexes:self.selectedEntities];
    self.entities = self.entities;
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    unichar keyCode = [theEvent keyCode];
    if (keyCode == kVK_ForwardDelete || keyCode == kVK_Delete) {
        [self remove:nil];
    }
}

- (IBAction)add:(id)sender {
    [self addEntity];
    [self.tableView deselectAll:nil];
}

- (IBAction)remove:(id)sender {
    [self removeSelectedEntities];
    [self.tableView deselectAll:nil];
}

- (IBAction)generate:(id)sender {
    Generator *generator = [[Generator alloc] init];
    generator.className = self.className;
    generator.superClassName = self.superClassName;
    generator.entities = self.entities;
    
    NSTimeInterval startInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *h_content = generator.h_content;
    NSString *m_content = generator.m_content;
    
    NSTimeInterval endInterval = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"%f", endInterval - startInterval);
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"Select";
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", [directoryURL absoluteString], self.className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", [directoryURL absoluteString], self.className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];            

            [m_content writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
