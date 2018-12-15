//
//  SUAIScheduleViewController.h
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUAIEntity;
@interface SUAIScheduleViewController : UIViewController

- (instancetype)initWithEntity:(SUAIEntity *)entity;

@end

NS_ASSUME_NONNULL_END
