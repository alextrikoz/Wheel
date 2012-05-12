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
@synthesize classNameTextField = _classNameTextField;
@synthesize superClassNameTextField = _superClassNameTextField;

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
    NSString *className = self.classNameTextField.stringValue;
    NSString *superClassName = self.superClassNameTextField.stringValue;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *createdDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *copyrightDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    NSString *myName = [[defaults values] valueForKey:@"MyName"];
    NSString *myCompanyName = [[defaults values] valueForKey:@"MyCompanyName"];
    NSString *myProjectName = [[defaults values] valueForKey:@"MyProjectName"];
    
    NSString *h_properties = @"";
    NSString *m_synthesize_properties = @"";
    NSString *m_release_properties = @"";
    NSString *m_dictionary_properties = @"";
    NSString *m_copy_properties = @"";
    NSString *m_decoder_properties = @"";
    NSString *m_coder_properties = @"";
    for (Entity *entity in self.dataStore.entities) {
        h_properties = [h_properties stringByAppendingString:[entity propertyFormat]];
        m_synthesize_properties = [m_synthesize_properties stringByAppendingString:[entity synthesizeFormat]];
        m_release_properties = [m_release_properties stringByAppendingString:[entity releaseFormat]];
        m_dictionary_properties = [m_dictionary_properties stringByAppendingString:[entity dictionaryFormat]];
        m_copy_properties = [m_copy_properties stringByAppendingString:[entity copyFormat]];
        m_decoder_properties = [m_decoder_properties stringByAppendingString:[entity decoderFormat]];
        m_coder_properties = [m_coder_properties stringByAppendingString:[entity coderFormat]];
    }
    
    NSString *protocols = @"";
    if (self.dataStore.isCopyingEnabled && self.dataStore.isCodingEnabled) {
        protocols = @"<NSCopying, NSCoding>";
    } else if (self.dataStore.isCopyingEnabled) {
        protocols = @"<NSCopying>";
    } else if (self.dataStore.isCodingEnabled) {
        protocols = @"<NSCoding>";
    }
    
    NSString *h_file_name = [className stringByAppendingString:@".h"];
    NSString *h_header = HEADER(h_file_name, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
    h_properties = self.dataStore.isPropertiesEnabled ? H_PROPERTIES(h_properties) : @"";
    NSString *initWithDictionaryPrototype = self.dataStore.isInitWithDictionaryEnabled ? H_INITWITHDICTIONARY_PROTOTYPE : @"";
    NSString *objectWithDictionaryPrototype = self.dataStore.isObjectWithDictionaryEnabled ? H_OBJECTWITHDICTIONARY_PROTOTYPE : @"";
    NSString *objectsWithArrayPrototype = self.dataStore.isObjectsWithArrayEnabled ? H_OBJECTSWITHARRAY_PROTOTYPE : @"";
    NSString *h_prototypes = self.dataStore.isPrototypesEnabled ? H_PROTOTYPES(initWithDictionaryPrototype, objectWithDictionaryPrototype, objectsWithArrayPrototype) : @"";
    NSString *h_content = H_CONTENT(h_header, className, superClassName, protocols, h_properties, h_prototypes);
    
    NSString *m_file_name = [className stringByAppendingString:@".m"];
    NSString *m_header = HEADER(m_file_name, myProjectName, myName, createdDate, copyrightDate, myCompanyName);
    m_synthesize_properties = self.dataStore.isPropertiesEnabled ? SYNTHESIZE(m_synthesize_properties) : @"";
    NSString *dealloc = self.dataStore.isDeallocEnabled ? DEALLOC(m_release_properties) : @"";
    NSString *initwithdictionary = self.dataStore.isInitWithDictionaryEnabled ? INITWITHDICTIONARY(m_dictionary_properties) : @"";
    NSString *objectwithdictionary = self.dataStore.isObjectWithDictionaryEnabled ? OBJECTWITHDICTIONARY : @"";
    NSString *objectswitharray = self.dataStore.isObjectsWithArrayEnabled ? OBJECTSWITHARRAY : @"";
    NSString *copywithzone = self.dataStore.isCopyingEnabled ? COPYWITHZONE(className, m_copy_properties) : @"";
    NSString *initwithcoder = self.dataStore.isCodingEnabled ? INITWITHCODER(m_decoder_properties) : @"";
    NSString *encodewithcoder = self.dataStore.isCodingEnabled ? ENCODEWITHCODER(m_coder_properties) : @"";
    NSString *m_context = M_CONTENT(m_header, className, m_synthesize_properties, dealloc, initwithdictionary, objectwithdictionary, objectswitharray, copywithzone, initwithcoder, encodewithcoder);
    
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
