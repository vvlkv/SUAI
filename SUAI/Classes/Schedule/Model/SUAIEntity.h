//
//  SUAIEntity.h
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUAIEntity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sessionCode;
@property (strong, nonatomic) NSString *semesterCode;
@property (assign, nonatomic) EntityType type;

- (instancetype)initWithName:(NSString *)name
                 sessionCode:(NSString *)sessionCode
                semesterCode:(NSString *)semesterCode
                        type:(EntityType)type;


@end

NS_ASSUME_NONNULL_END
