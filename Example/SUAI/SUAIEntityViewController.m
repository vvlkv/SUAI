//
//  SUAIEntityViewController.m
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIEntityViewController.h"
#import "SUAIScheduleViewController.h"
#import "SUAIScheduleProvider.h"
#import "SUAI.h"

@interface SUAIEntityViewController () <SUAIScheduleDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_entitiesTableView;
    UISegmentedControl *_entityControl;
    NSArray <NSString *> *_entityNames;
    UIActivityIndicatorView *_indicator;
}

@end

@implementation SUAIEntityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _entityNames = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SUAISchedule demo";
    [self configureTableView];
    [self configureIndicator];
    [self configureSegmentedControl];
    [SUAIScheduleProvider instance].delegate = self;
}

- (void)configureIndicator {
    CGRect indicatorFrame = CGRectMake(self.view.bounds.size.width/2 - 10, self.view.bounds.size.height/2 - 10, 20, 20);
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = indicatorFrame;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
}

- (void)configureTableView {
    CGRect tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    _entitiesTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _entitiesTableView.delegate = self;
    _entitiesTableView.dataSource = self;
    _entitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_entitiesTableView];
}

- (void)configureSegmentedControl {
    _entityControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Groups", @"Teachers", nil]];
    _entityControl.frame = CGRectMake(16, self.view.bounds.size.height - 36, self.view.bounds.size.width - 32, 28);
    _entityControl.selectedSegmentIndex = 0;
    [_entityControl addTarget:self action:@selector(didChangeEntityType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_entityControl];
}

- (void)didChangeStatus:(Status)status {
    [_indicator stopAnimating];
    _entitiesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self changeVisibleEntities:Group];
}

- (void)didChangeEntityType:(UISegmentedControl *)sender {
    [self changeVisibleEntities:(Entity)sender.selectedSegmentIndex];
}

- (void)changeVisibleEntities:(Entity)type {
    SUAIEntity *entity = [SUAIScheduleProvider instance].teachers[69];
    [[SUAI instance].schedule loadScheduleFor:entity success:^(SUAISchedule *schedule) {
    } fail:^(NSString *fail) {
    }];
    [_entitiesTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SUAIScheduleViewController *scheduleViewController = [[SUAIScheduleViewController alloc] initWithEntityName:_entityNames[indexPath.row]
                                                                                                        andType:(Entity)_entityControl.selectedSegmentIndex];
    [self.navigationController pushViewController:scheduleViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_entityNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = _entityNames[indexPath.row];
    return cell;
}

@end
