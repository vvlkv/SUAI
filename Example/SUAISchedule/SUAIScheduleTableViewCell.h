//
//  SUAIScheduleTableViewCell.h
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUAIScheduleTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *auditory;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray <NSString *> *teachers;
@property (strong, nonatomic) NSArray <NSString *> *groups;

@end

NS_ASSUME_NONNULL_END
