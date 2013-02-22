//
//  XMLParser.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLParser.h"

@interface XMLParser () <NSXMLParserDelegate>

@property NSMutableString *text;
@property NSMutableArray *stack;

@end

@implementation XMLParser

+ (NSDictionary *)dictionaryWithData:(NSData *)data {
    XMLParser *myParser = [XMLParser new];
    
    myParser.text = @"".mutableCopy;
    myParser.stack = @[@{}.mutableCopy].mutableCopy;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = myParser;
    [parser parse];
    
    return myParser.stack.lastObject;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {    
    self.stack.lastObject[elementName] = attributeDict.mutableCopy;
    self.stack[self.stack.count] = self.stack.lastObject[elementName];
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
    [[NSAlert alertWithError:parseError] runModal];
    self.stack = nil;
}

@end
