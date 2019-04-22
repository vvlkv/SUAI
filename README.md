# SUAI

[![CI Status](https://img.shields.io/travis/vvlkv/SUAI.svg?style=flat)](https://travis-ci.org/vvlkv/SUAI)
[![Version](https://img.shields.io/cocoapods/v/SUAI.svg?style=flat)](https://cocoapods.org/pods/SUAI)
[![License](https://img.shields.io/cocoapods/l/SUAI.svg?style=flat)](https://cocoapods.org/pods/SUAI)
[![Platform](https://img.shields.io/cocoapods/p/SUAI.svg?style=flat)](https://cocoapods.org/pods/SUAI)
###
SUAI is a lightweight and very simple library for working with contents of [Saint Petersburg State University of Aerospace Instrumentation](http://suai.ru).
Using this library you can:
* Obtain schedule of groups, teachers and auditories referenced from [scheduling site](http://rasp.guap.ru);
* Obtain university news.

This library used in Official SUAI app "[Спутник ГУАП](https://itunes.apple.com/ru/app/спутник-гуап/id1234040508?l=en&mt=8)".
## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SUAI is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'SUAI'
```
## Usage
### Schedule
If you know name of entity and it's type, use:
```Objective-C
- (void)loadScheduleFor:(NSString *)entityName
                 ofType:(Entity)type
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;
```
or if you have SUAIEntity object of entity, use:
```Objective-C
- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;
```
Above methods are similar, if schedule have been obtained without errors, success block will be called. In any cases fail block is to your service :).
Example how to load schedule of type: Group with name "1741":
#### Objective-C
```Objective-C
[[[SUAI instance] schedule] loadScheduleFor:@"1741" ofType:EntityTypeGroup success:^(SUAISchedule *schedule) {
        NSLog(@"OK: %@", schedule);
} fail:^(__kindof SUAIError *error) {
        NSLog(@"error: %@", error.description)
}];
```
#### Swift
```Swift
SUAI.instance().schedule.loadSchedule(for: "1741", of: .group, success: { (schedule) in
    print("OK: \(schedule)")
}) { (error) in
    print("error: \(error.description)")
}
```
### News
For load available news preview use this method:
```Objective-C
- (void)loadAllNews:(void (^) (NSArray<SUAINews *>* news))success
               fail:(void (^) (SUAIError *err))error;
```
If you want to load concrete news use:
```Objective-C
- (void)loadNews:(NSString *)newsID
         success:(void (^) (SUAINews *news))success
            fail:(void (^) (SUAIError *err))error;
```
Where newsID is a part of url stored in property *publicationId* of SUAINews object.

### Notifications

Library also contain notification constants. Subscribe on it if you need to react on it's changing:
* kSUAIReachabilityNotification
If you subscribed on this notification constant, you will be able to handle internet reachability changes  (e.g. device is offline or connected via Wi-fi or LTE). In notification object you will get NSNumber contains bool value with reachability status.
Example:
Somewhere you subscribed on notification:

```Objective-C
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(p_internetReachabilityChanged:)
                                             name:kSUAIReachabilityNotification object:nil];
```
And in method *p_internetReachabilityChanged* you can check reachability status:
```Objective-C
- (void)p_internetReachabilityChanged:(NSNotification *)notification {
    BOOL isReachable = [(NSNumber *)[notification object] boolValue];
    NSLog(@"internet is reachable: %ld", isReachable);
}
```
* kSUAIWeekTypeObtainedNotification
Constant will notify when SUAI loaded current week type of week.
* kSUAIEntityLoadedNotification
Before you be able to load schedule, it's necessary to load all available codes. This contant will notify when all codes are loaded and ready to work.

### Important
Don't forget to allow arbitrary loads!
1. Go to plist file;
2. In information property list add new key "App Transport Security Settings";
3. In added dictionary add key "Allow Arbitrary Loads" and set value to YES.
## Requirements
* Xcode
* Objective-C
* iOS 9.0 or higher

## Author

Victor Volkov, vvlkv@icloud.com

## License

SUAI is available under the MIT license. See the LICENSE file for more info.
