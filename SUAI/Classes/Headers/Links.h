//
//  Links.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#ifndef Links_h
#define Links_h
//#define LOCAL

#ifdef LOCAL
static NSString *const semesterLink = @"http://192.168.1.2:8080";
static NSString *const sessionLink = @"http://192.168.1.2:8080";
static NSString *const newsLink = @"http://192.168.1.2:8080";
static NSString *const publicationsLink = @"http://192.168.1.2:8080";
#else
static NSString *const semesterLink = @"http://rasp.guap.ru";
static NSString *const sessionLink = @"http://raspsess.guap.ru";
static NSString *const newsLink = @"http://new.guap.ru";
static NSString *const publicationsLink = @"http://new.guap.ru/pubs";
#endif
#endif /* Links_h */
