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
@synthesize types = _types;

@synthesize classNameTextField = _classNameTextField;
@synthesize superClassNameTextField = _superClassNameTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.entities = [NSMutableArray array];
    
    Entity *entity = [[Entity alloc] init];
    entity.type = @"NSString *";
    entity.name = @"title";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSString *";
    entity.name = @"subtitle";
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSDate *";
    entity.name = @"date";    
    [self.entities addObject:entity];
    
    entity = [[Entity alloc] init];
    entity.type = @"NSArray *";
    entity.name = @"items";    
    [self.entities addObject:entity];
    
    self.entities = self.entities;
    
    self.types = [NSMutableArray array];
    
    [self.types addObject:@"NSArray *"];
    [self.types addObject:@"NSDate *"];
    [self.types addObject:@"NSDictionary *"];
    [self.types addObject:@"NSNumber *"];
    [self.types addObject:@"NSString *"];
    
    self.types = self.types;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntity:) name:@"removeEntity" object:nil];
}

- (IBAction)add:(id)sender {    
    Entity *entity = [[Entity alloc] init];
    entity.type = @"NSArray *";
    entity.name = @"items";
    [self.entities addObject:entity];
    
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
    
    NSString *h_content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"h" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *h_properties = @"\n";
    for (Entity *entity in self.entities) {
        h_properties = [h_properties stringByAppendingFormat:@"@property (strong, nonatomic) %@%@;\n", entity.type, entity.name];
    }
    h_content = [NSString stringWithFormat:h_content, className, myName, myCompanyName, className, superClassName, h_properties];
    
    NSString *m_context = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"m" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *m_synthesize_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_synthesize_properties = [m_synthesize_properties stringByAppendingFormat:@"@synthesize %@ = _%@;\n", entity.name, entity.name];
    }
    NSString *m_release_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_release_properties = [m_release_properties stringByAppendingFormat:@"    [_%@ release];\n", entity.name];
    }
    NSString *m_dictionary_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_dictionary_properties = [m_dictionary_properties stringByAppendingFormat:@"        self.%@ = [dictionary objectForKey:@\"%@\"];\n", entity.name, entity.name];
    }
    NSString *m_copy_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_copy_properties = [m_copy_properties stringByAppendingFormat:@"    object.%@ = self.%@;\n", entity.name, entity.name];
    }
    NSString *m_coder_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_coder_properties = [m_coder_properties stringByAppendingFormat:@"    coder.%@ = self.%@;\n", entity.name, entity.name];
    }
    NSString *m_decoder_properties = @"\n";
    for (Entity *entity in self.entities) {
        m_decoder_properties = [m_decoder_properties stringByAppendingFormat:@"        self.%@ = [decoder decodeObjectForKey:@\"%@\"];\n", entity.name, entity.name];
    }
    m_context = [NSString stringWithFormat:m_context, className, myName, myCompanyName, className, className, m_synthesize_properties, m_release_properties, m_dictionary_properties, m_copy_properties, m_coder_properties, m_decoder_properties];
    
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
