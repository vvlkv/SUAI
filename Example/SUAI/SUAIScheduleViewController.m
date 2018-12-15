//
//  SUAIScheduleViewController.m
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIScheduleViewController.h"
#import "SUAISchedule.h"
#import "SUAIScheduleTableViewCell.h"
#import "SUAIPair.h"
#import "SUAIDay.h"
#import "SUAIAuditory.h"
#import "SUAI.h"
#import "SUAIEntity.h"
#import "SUAISchedule.h"

@interface SUAIScheduleViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    UIActivityIndicatorView *_indicator;
    NSArray <SUAIDay *> *_semesterSchedule;
    NSString *_name;
    Entity _type;
    
    SUAIEntity *_entity;
    __block SUAISchedule *_schedule;
}

@end

@implementation SUAIScheduleViewController

- (instancetype)initWithEntity:(SUAIEntity *)entity {
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

- (instancetype)initWithEntityName:(NSString *)name andType:(Entity)type
{
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
        _semesterSchedule = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _entity.name;
    [[[SUAI instance] schedule] loadScheduleFor:_entity success:^(SUAISchedule *schedule) {
        self->_schedule = schedule;
        [self->_tableView reloadData];
    } fail:^(NSString *fail) {
    }];
    [self configureTableView];
    [self configureIndicator];
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SUAIScheduleTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"CellId"];
    [self.view addSubview:_tableView];
}

- (void)configureIndicator {
    CGRect indicatorFrame = CGRectMake(self.view.bounds.size.width/2 - 10, self.view.bounds.size.height/2 - 10, 20, 20);
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = indicatorFrame;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_schedule.semester count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"todo";//_schedule.semester[section].day;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _schedule.semester[section].pairs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUAIScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    SUAIPair *pair = _schedule.semester[indexPath.section].pairs[indexPath.row];
    cell.name = pair.name;
    cell.teachers = pair.teachers;
    cell.time = pair.time;
    cell.type = pair.lessonType;
    cell.auditory = [pair.auditory fullDescription];
    cell.groups = pair.groups;
    return cell;
}
@end
