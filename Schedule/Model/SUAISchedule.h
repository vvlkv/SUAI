//
//  VVSchedule.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUAIDay;
@class SUAIPair;
@interface SUAISchedule : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic) NSArray<SUAIDay *> *session;
@property (strong, nonatomic) NSArray<SUAIDay *> *semester;

- (instancetype)initWithName:(NSString *)name;

@end
