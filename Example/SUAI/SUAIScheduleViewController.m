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
#import "SUAITime.h"

@interface SUAIScheduleViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    
    SUAIEntity *_entity;
    NSArray<SUAIDay *> *_content;
}

@property (strong, nonatomic) SUAISchedule *schedule;

@end

@implementation SUAIScheduleViewController

- (instancetype)initWithEntity:(SUAIEntity *)entity {
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _entity.name;
    __weak typeof(self) welf = self;
    [[[SUAI instance] schedule] loadScheduleFor:_entity
                                        success:^(SUAISchedule *schedule) {
        welf.schedule = schedule;
        [welf showSchedule:0];
    } fail:^(SUAIError *fail) {
        
    }];
    [self configureTableView];
    [self configureSegmentedControl];
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

- (void)configureSegmentedControl {
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"Sem", @"Ses"]];
    [control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    control.selectedSegmentIndex = 0;
    self.navigationItem.titleView = control;
}

- (void)didChangeSegment:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    [self showSchedule:index];
}

- (void)showSchedule:(NSUInteger)index {
    switch (index) {
        case 0:
            _content = [_schedule expandedScheduleToFullWeek:_schedule.semester];
            break;
        case 1:
            _content = _schedule.session;
            break;
        default:
            assert("wtf");
            break;
    }
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_content count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_content[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_content[section] pairs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUAIScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    SUAIPair *pair = _content[indexPath.section].pairs[indexPath.row];
    cell.name = pair.name;
    cell.teachers = pair.teachers;
    cell.time = [[pair time] stringValue];
    cell.type = pair.lessonType;
    cell.auditory = [pair.auditory fullDescription];
    cell.groups = pair.groups;
    return cell;
}

@end
