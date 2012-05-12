//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

#import "Config.h"

#import "Option.h"
#import "Entity.h"
#import "DataStore.h"

@implementation MainController

@synthesize dataStore = _dataStore;

@synthesize tableView = _tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView deselectRow:self.tableView.selectedRow];    
}

- (IBAction)add:(id)sender {    
    Entity *entity = [[Entity alloc] init];
    entity.checked = [NSNumber numberWithBool:NO];
    entity.setter = @"strong";
    entity.atomicity = @"nonatomic";
    entity.writability = @"readwrite";
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.dataStore.entities addObject:entity];
    
    self.dataStore.entities = self.dataStore.entities;
    
    [self.tableView deselectRow:self.tableView.selectedRow];
}

- (IBAction)remove:(id)sender {    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.dataStore.entities.count];
    for (Entity *entity in self.dataStore.entities) {
        if (!entity.checked.boolValue) {
            [temp addObject:entity];
        }
    }
    self.dataStore.entities = temp;
    [self.tableView deselectRow:self.tableView.selectedRow];
}

- (IBAction)generate:(id)sender {    
    NSString *className = self.dataStore.className;
    NSString *superClassName = self.dataStore.className;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *createdDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *copyrightDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    NSString *myName = [[defaults values] valueForKey:@"MyName"];
    NSString *myCompanyName = [[defaults values] valueForKey:@"MyCompanyName"];
    NSString *myProjectName = [[defaults values] valueForKey:@"MyProjectName"];
    
    NSString *h_file_name = [className stringByAppendingString:@".h"];
    NSString *h_header = HEADER(h_file_name, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
    NSString *h_protocols = self.dataStore.h_protocols;
    NSString *h_properties = self.dataStore.h_properties;
    NSString *h_prototypes = self.dataStore.h_prototypes;
    NSString *h_content = H_CONTENT(h_header, className, superClassName, h_protocols, h_properties, h_prototypes);
    
    NSString *m_file_name = [className stringByAppendingString:@".m"];
    NSString *m_header = HEADER(m_file_name, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
    NSString *m_synthesize_properties = self.dataStore.m_synthesizes;
    NSString *m_dealloc = self.dataStore.m_dealloc;
    NSString *m_initWithDictionary = self.dataStore.m_initWithDictionary;
    NSString *m_objectWithDictionary = self.dataStore.m_objectWithDictionary;
    NSString *m_objectsWithArrayEnabled = self.dataStore.m_objectsWithArrayEnabled;
    NSString *m_copyWithZone = self.dataStore.m_copyWithZone;
    NSString *m_initWithCoder = self.dataStore.m_initWithCoder;
    NSString *m_encodeWithCoder = self.dataStore.m_encodeWithCoder;
    NSString *m_context = M_CONTENT(m_header, className, m_synthesize_properties, m_dealloc, m_initWithDictionary, m_objectWithDictionary, m_objectsWithArrayEnabled, m_copyWithZone, m_initWithCoder, m_encodeWithCoder);
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"Select"];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", [directoryURL absoluteString], className]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", [directoryURL absoluteString], className]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];            
            
            [m_context writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
