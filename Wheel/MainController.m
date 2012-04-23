//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"

#import "Entity.h"
#import "DataStore.h"

@implementation MainController

@synthesize dataStore = _dataStore;

@synthesize tableView = _tableView;
@synthesize classNameTextField = _classNameTextField;
@synthesize superClassNameTextField = _superClassNameTextField;

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
    NSString *className = self.classNameTextField.stringValue;
    NSString *superClassName = self.superClassNameTextField.stringValue;
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    NSString *myName = [[defaults values] valueForKey:@"MyName"];
    NSString *myCompanyName = [[defaults values] valueForKey:@"MyCompanyName"];
    NSString *myProjectName = [[defaults values] valueForKey:@"MyProjectName"];
    
    NSString *h_content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"h" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *h_properties = @"\n";   
    
    NSString *m_context = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"m" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *m_synthesize_properties = @"\n";
    NSString *m_release_properties = @"\n";
    NSString *m_dictionary_properties = @"\n";
    NSString *m_copy_properties = @"\n";
    NSString *m_coder_properties = @"\n";
    NSString *m_decoder_properties = @"\n";
    for (Entity *entity in self.dataStore.entities) {
        h_properties = [h_properties stringByAppendingString:[entity propertyFormat]];
        
        m_synthesize_properties = [m_synthesize_properties stringByAppendingString:[entity synthesizeFormat]];
        m_release_properties = [m_release_properties stringByAppendingString:[entity releaseFormat]];
        m_dictionary_properties = [m_dictionary_properties stringByAppendingString:[entity dictionaryFormat]];
        m_copy_properties = [m_copy_properties stringByAppendingString:[entity copyFormat]];
        m_coder_properties = [m_coder_properties stringByAppendingString:[entity coderFormat]];
        m_decoder_properties = [m_decoder_properties stringByAppendingString:[entity decoderFormat]];
    }
    h_content = [NSString stringWithFormat:h_content, className, myProjectName, myName, myCompanyName, className, superClassName, h_properties];
    
    m_context = [NSString stringWithFormat:m_context, className, myProjectName, myName, myCompanyName, className, className, m_synthesize_properties, m_release_properties, m_dictionary_properties, m_copy_properties, m_coder_properties, m_decoder_properties];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"Select"];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            NSURL *directoryURL = openPanel.directoryURL;
            NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.h", [directoryURL absoluteString], self.classNameTextField.stringValue]];
            NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.m", [directoryURL absoluteString], self.classNameTextField.stringValue]];
            
            [h_content writeToURL:hURL atomically:YES encoding:NSUTF8StringEncoding error:nil];            
            
            [m_context writeToURL:mURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
