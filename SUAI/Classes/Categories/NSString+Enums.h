//
//  NSString+Enums.h
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Enums)

+ (NSString *)convertToString:(EntityType)entity;
+ (EntityType)convertToEntity:(NSString *)entity;

@end

NS_ASSUME_NONNULL_END
