//
//  SUAINews.h
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;
@interface SUAINews : NSObject

@property (strong, nonatomic) NSString *publicationId;
@property (strong, nonatomic) NSString *imageSource;
@property (strong, nonatomic) NSString *header;
@property (strong, nonatomic) NSString *subHeader;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
