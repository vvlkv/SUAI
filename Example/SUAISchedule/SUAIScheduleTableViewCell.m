//
//  SUAIScheduleTableViewCell.m
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIScheduleTableViewCell.h"

@interface SUAIScheduleTableViewCell () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *auditoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupsLabel;

@end

@implementation SUAIScheduleTableViewCell

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = [NSString stringWithFormat:@"pair time: %@", _time];
}

- (void)setType:(NSString *)type {
    _type = type;
    self.typeLabel.text = [NSString stringWithFormat:@"type: %@", _type];
}

- (void)setAuditory:(NSString *)auditory {
    _auditory = auditory;
    self.auditoryLabel.text = [NSString stringWithFormat:@"auditory: %@", _auditory];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = [NSString stringWithFormat:@"name: %@", _name];
}

- (void)setTeachers:(NSArray <NSString *> *)teachers {
    _teachers = teachers;
    self.teacherLabel.text = [NSString stringWithFormat:@"teachers: %@", [self fillElementsFrom:_teachers]];
}

- (void)setGroups:(NSArray<NSString *> *)groups {
    _groups = groups;
    self.groupsLabel.text = [NSString stringWithFormat:@"groups: %@", [self fillElementsFrom:_groups]];
}

- (NSString *)fillElementsFrom:(NSArray<NSString *> *)contents {
    NSMutableString *elementsStr = [[NSMutableString alloc] init];
    for (NSString *element in contents) {
        [elementsStr appendString:[NSString stringWithFormat:@"%@ ", element]];
    }
    return elementsStr;
}

@end
