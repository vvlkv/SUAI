//
//  VVDay.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUAIPair;
@interface SUAIDay: NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic, readonly) NSArray<SUAIPair *> *pairs;

- (instancetype)initWithName:(NSString *)name
                   andPairs:(NSArray<SUAIPair *> *)pairs;

@end
