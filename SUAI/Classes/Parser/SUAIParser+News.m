//
//  SUAIParser+News.m
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAIParser+News.h"
#import "SUAINews.h"
#import "HTMLKit.h"
#import "NSString+NameFormation.h"

@implementation SUAIParser (News)

+ (NSArray<SUAINews *> *)allNewsFromData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    NSArray *news = [document querySelectorAll:@".item-news"];
    
    NSMutableArray<SUAINews *> *contents = [NSMutableArray arrayWithCapacity:[news count]];
    
    for (HTMLElement *element in news) {
        SUAINews *news = [[SUAINews alloc] init];
        HTMLElement *pub = [element querySelector:@"a"];
        news.publicationId = pub.attributes[@"href"];
        
        HTMLElement *img = [pub querySelector:@"img"];
        news.imageSource = img.attributes[@"src"];
        
        HTMLElement *head = [pub querySelector:@"h3"];
        HTMLElement *date = [head querySelector:@"span"];
        news.date = date.textContent;
        news.header = [head.childNodes.lastObject.textContent removeSlashes];
        
        HTMLElement *txt = [pub querySelector:@"p"];
        news.text = txt.textContent;
        [contents addObject:news];
    }
    return contents;
}

+ (SUAINews *)newsFromData:(NSData *)data {
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataStr];
    HTMLElement *content = [document querySelector:@".header"];
    HTMLElement *header = [content querySelector:@"h1"];
    HTMLElement *date = [header querySelector:@"span"];
    SUAINews *news = [[SUAINews alloc] init];
    news.date = date.textContent;
    news.header = [header.lastChild.textContent removeSlashes];
    HTMLElement *mainPart = [document querySelector:@".col-xs-9"];
    HTMLElement *gallery = [mainPart querySelector:@"a"];
    news.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gallery.attributes[@"href"]]]];
    news.text = [mainPart.textContent removeSlashes];
    HTMLElement *subHeader = [mainPart querySelector:@".lead"];
    news.subHeader = [[subHeader textContent] removeSlashes];
    return news;
}

@end
