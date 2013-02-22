//
//  XMLParser.m
//  Wheel
//
//  Created by Alexander on 22.02.13.
//
//

#import "XMLParser.h"

@interface XMLParser () <NSXMLParserDelegate>

@property NSMutableDictionary *dictionary;
@property NSMutableString *text;

@end

@implementation XMLParser

+ (NSDictionary *)dictionaryWithData:(NSData *)data {
    XMLParser *myParser = [XMLParser new];
    
    myParser.dictionary = @{}.mutableCopy;
    myParser.text = @"".mutableCopy;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = myParser;
    [parser parse];
    
    return myParser.dictionary;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self.dictionary addEntriesFromDictionary:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (self.text.length) {
        self.dictionary[elementName] = self.text;
        self.text = @"".mutableCopy;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.text appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [[NSAlert alertWithError:parseError] runModal];
}

@end
