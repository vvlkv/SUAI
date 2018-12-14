//
//  SUAIScheduleViewController.m
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIScheduleViewController.h"
#import "SUAIScheduleProvider.h"
#import "SUAISchedule.h"
#import "SUAIScheduleTableViewCell.h"
#import "SUAIPair.h"
#import "SUAIDay.h"
#import "SUAIAuditory.h"
#import "SUAI.h"

@interface SUAIScheduleViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_scheduleTableView;
    UIActivityIndicatorView *_indicator;
    NSArray <SUAIDay *> *_semesterSchedule;
    NSString *_name;
    Entity _type;
}

@end

@implementation SUAIScheduleViewController

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
    self.title = _name;
    [self configureTableView];
    [self configureIndicator];
}

- (void)configureTableView {
    _scheduleTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _scheduleTableView.delegate = self;
    _scheduleTableView.dataSource = self;
    _scheduleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scheduleTableView registerNib:[UINib nibWithNibName:@"SUAIScheduleTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"CellId"];
    [self.view addSubview:_scheduleTableView];
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
    return [_semesterSchedule count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((SUAIDay *)_semesterSchedule[section]).day;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SUAIDay *day = (SUAIDay *)_semesterSchedule[section];
    return [day.pairs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUAIScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    SUAIPair *pair = ((SUAIDay *)_semesterSchedule[indexPath.section]).pairs[indexPath.row];
    cell.name = pair.name;
    cell.teachers = pair.teachers;
    cell.time = pair.time;
    cell.type = pair.lessonType;
    cell.auditory = [pair.auditory fullDescription];
    cell.groups = pair.groups;
    return cell;
}
@end
