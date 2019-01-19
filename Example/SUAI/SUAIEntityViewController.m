//
//  SUAIEntityViewController.m
//  SUAISchedule_Example
//
//  Created by Виктор on 09/08/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIEntityViewController.h"
#import "SUAIScheduleViewController.h"
#import "SUAI.h"
#import "SUAIEntity.h"

@interface SUAIEntityViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    UISegmentedControl *_entityControl;
    UIActivityIndicatorView *_indicator;
    NSArray<SUAIEntity *> *_entities;
}

@end

@implementation SUAIEntityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Schedule";
    [self configureTableView];
    [self configureSegmentedControl];
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (void)configureIndicator {
    CGRect indicatorFrame = CGRectMake(self.view.bounds.size.width/2 - 10, self.view.bounds.size.height/2 - 10, 20, 20);
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = indicatorFrame;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
}

- (void)configureSegmentedControl {
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"Groups", @"Teachers", @"Auditories"]];
    [control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    control.selectedSegmentIndex = 0;
    self.navigationItem.titleView = control;
}

- (void)didChangeSegment:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    [self showEntities:index];
}

- (void)showEntities:(NSUInteger)index {
    switch (index) {
        case 0:
            _entities = [[SUAI instance] schedule].groups;
            break;
        case 1:
            _entities = [[SUAI instance] schedule].teachers;
            break;
        case 2:
            _entities = [[SUAI instance] schedule].auditories;
            break;
        default:
            assert("wtf");
            break;
    }
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SUAIScheduleViewController *vc = [[SUAIScheduleViewController alloc] initWithEntity:_entities[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_entities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %ld", indexPath.row, indexPath.section];
    cell.textLabel.text = _entities[indexPath.row].name;
    return cell;
}

@end
