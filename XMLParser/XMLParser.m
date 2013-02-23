//
//  XMLParser.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLParser.h"

@interface XMLParser () <NSXMLParserDelegate>

@property NSError *error;
@property NSMutableString *text;
@property NSMutableArray *stack;

@end

@implementation XMLParser

+ (NSDictionary *)dictionaryWithData:(NSData *)data error:(NSError **)error {
    XMLParser *myParser = [XMLParser new];
    
    myParser.text = @"".mutableCopy;
    myParser.stack = @[@{}.mutableCopy].mutableCopy;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = myParser;
    [parser parse];
    
    *error = myParser.error;
    
    return myParser.stack.lastObject;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {    
    NSMutableDictionary *mutableAttributes = attributeDict.mutableCopy;
    id object = self.stack.lastObject[elementName];
    if (object) {
        NSMutableArray *array = nil;
        if ([object isKindOfClass:[NSMutableArray class]]) {
            array = object;
        } else {
            array = @[object].mutableCopy;
            self.stack.lastObject[elementName] = array;
        }
        array[array.count] = mutableAttributes;
    } else {
        self.stack.lastObject[elementName] = mutableAttributes;
    }
    self.stack[self.stack.count] = mutableAttributes;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (self.text.length) {
        self.stack.lastObject[elementName] = self.text;
        self.text = @"".mutableCopy;
    }
    [self.stack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.text appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.error = parseError;
    self.stack = nil;
}

@end
