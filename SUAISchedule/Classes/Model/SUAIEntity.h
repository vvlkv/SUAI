//
//  SUAIEntity.h
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUAIEntity : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *sessionCode;
@property (strong, nonatomic, readonly) NSString *semesterCode;

- (instancetype)initWithName:(NSString *)name
                 sessionCode:(NSString *)sessionCode
             andSemesterCode:(NSString *)semesterCode;

@end

NS_ASSUME_NONNULL_END
