//
//  WindowController.m
//  Wheel
//
//  Created by Alexander on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WindowController.h"

#import "Entity.h"
#import "EntityView.h"

@implementation WindowController

@synthesize entities = _entities;
@synthesize setters = _setters;
@synthesize types = _types;

@synthesize classNameTextField = _classNameTextField;
@synthesize superClassNameTextField = _superClassNameTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.entities = [NSMutableArray array];
    
    Entity *entity = [[Entity alloc] init];
    entity.type = @"NSString *";
    entity.name = @"title";
    entity.setter = @"copy";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    entity.setter = @"copy";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSDate *";
    entity.name = @"date";
    entity.setter = @"strong";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSArray *";
    entity.name = @"items";
    entity.setter = @"strong"; 
    [self.entities addObject:entity];
    
    self.entities = self.entities;
    
    self.types = [NSMutableArray array];
    
    [self.types addObject:@"NSArray *"];
    [self.types addObject:@"NSDate *"];
    [self.types addObject:@"NSDictionary *"];
    [self.types addObject:@"NSNumber *"];
    [self.types addObject:@"NSString *"];
    
    self.types = self.types;
    
    self.setters = [NSMutableArray array];
    
    [self.setters addObject:@"assign"];
    [self.setters addObject:@"copy"];
    [self.setters addObject:@"retain"];
    [self.setters addObject:@"strong"];
    [self.setters addObject:@"unsafe_unretained"];
    [self.setters addObject:@"week"];
    
    self.setters = self.setters;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntity:) name:@"removeEntity" object:nil];
}

- (IBAction)add:(id)sender {    
    Entity *entity = [[Entity alloc] init];
    entity.type = @"NSArray *";
    entity.name = @"items";
    entity.setter = @"strong"; 
    [self.entities addObject:entity];
    
    self.entities = self.entities;
}

- (IBAction)remove:(id)sender {    
    [self.entities removeAllObjects];
    
    self.entities = self.entities;
}

- (void)removeEntity:(NSNotification *)notification {
    [self.entities removeObject:notification.object];
    
    self.entities = self.entities;
}

- (IBAction)onGenerateClick:(id)sender {
    NSString *className = self.classNameTextField.stringValue;
    NSString *superClassName = self.superClassNameTextField.stringValue;
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    NSString *myName = [[defaults values] valueForKey:@"MyName"];
    NSString *myCompanyName = [[defaults values] valueForKey:@"MyCompanyName"];
    NSString *myProjectName = [[defaults values] valueForKey:@"MyProjectName"];
    
    NSString *h_content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"h" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *h_properties = @"\n";
    for (Entity *entity in self.entities) {
        h_properties = [h_properties stringByAppendingString:[entity propertyFormat]];
    }
    h_content = [NSString stringWithFormat:h_content, className, myProjectName, myName, myCompanyName, className, superClassName, h_properties];
    
    NSString *m_context = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"m" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *m_synthesize_properties = @"\n";
    NSString *m_release_properties = @"\n";
    NSString *m_dictionary_properties = @"\n";
    NSString *m_copy_properties = @"\n";
    NSString *m_coder_properties = @"\n";
    NSString *m_decoder_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_synthesize_properties = [m_synthesize_properties stringByAppendingString:[entity synthesizeFormat]];
        m_release_properties = [m_release_properties stringByAppendingString:[entity releaseFormat]];
        m_dictionary_properties = [m_dictionary_properties stringByAppendingString:[entity dictionaryFormat]];
        m_copy_properties = [m_copy_properties stringByAppendingString:[entity copyFormat]];
        m_coder_properties = [m_coder_properties stringByAppendingString:[entity coderFormat]];
        m_decoder_properties = [m_decoder_properties stringByAppendingString:[entity decoderFormat]];
    }
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
