//
//  SUAIAllNewsViewController.m
//  SUAI_Example
//
//  Created by Виктор on 15/12/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIAllNewsViewController.h"
#import "SUAIConcreteNewsViewController.h"
#import "SUAI.h"
#import "SUAINews.h"

@interface SUAIAllNewsViewController ()

@property (strong, nonatomic) NSArray <SUAINews *> *content;

@end

@implementation SUAIAllNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"News";
    __weak typeof(self) welf = self;
    [[[SUAI instance] news] loadAllNews:^(NSArray<SUAINews *> * _Nonnull news) {
        welf.content = news;
        [welf.tableView reloadData];
    } fail:^(NSString * _Nonnull fail) {
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SUAINews *news = _content[indexPath.row];
    SUAIConcreteNewsViewController *vc = [[SUAIConcreteNewsViewController alloc] initWithNewsID:news.publicationId];
    [self.navigationController pushViewController:vc animated:YES];
//    [[[SUAI instance] news] loadNews:news.publicationId success:^(SUAINews * _Nonnull news) {
//        NSLog(@"OK");
//    } fail:^(NSString * _Nonnull fail) {
//        NSLog(@"FAIL");
//    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = self.content[indexPath.row].header;
    return cell;
}

@end
