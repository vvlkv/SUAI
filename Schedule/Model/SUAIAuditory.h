//
//  SUAIAuditory.h
//  SUAIParser
//
//  Created by Виктор on 07/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Building) {
    BM,
    Gast,
    Lens,
    Undefined
};

@interface SUAIAuditory : NSObject

@property (strong, nonatomic, readonly) NSString *number;
@property (assign, nonatomic, readonly) Building building;
@property (strong, nonatomic, readonly) NSString *fullDescription;

- (instancetype)initWithString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
