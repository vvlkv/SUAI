//
//  SUAIConcreteNewsViewController.m
//  SUAI_Example
//
//  Created by Виктор on 16/12/2018.
//  Copyright © 2018 vvlkv. All rights reserved.
//

#import "SUAIConcreteNewsViewController.h"
#import "SUAI.h"
#import "SUAINews.h"

@interface SUAIConcreteNewsViewController () {
    NSString *newsId;
}
@property (weak, nonatomic) IBOutlet UILabel *headerLabe;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textView;

@end

@implementation SUAIConcreteNewsViewController

- (instancetype)initWithNewsID:(NSString *)newsID {
    self = [super init];
    if (self) {
        newsId = newsID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self) welf = self;
    [[[SUAI instance] news] loadNews:newsId success:^(SUAINews * _Nonnull news) {
        welf.headerLabe.text = news.header;
        welf.dateLabel.text = news.date;
        welf.imageView.image = news.image;
        welf.textView.text = news.text;
    } fail:^(NSString * _Nonnull fail) {
        
    }];
}

@end
