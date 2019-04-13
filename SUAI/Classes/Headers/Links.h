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
static NSString *semesterLink = @"http://192.168.1.2:8080";
static NSString *sessionLink = @"http://192.168.1.2:8080";
static NSString *newsLink = @"http://192.168.1.2:8080";
#else
static NSString *semesterLink = @"http://rasp.guap.ru";
static NSString *sessionLink = @"http://raspsess.guap.ru";
static NSString *newsLink = @"http://new.guap.ru/pubs";
#endif
#endif /* Links_h */
