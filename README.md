# SUAI

[![CI Status](https://img.shields.io/travis/vvlkv/SUAISchedule.svg?style=flat)](https://travis-ci.org/vvlkv/SUAISchedule)
[![Version](https://img.shields.io/cocoapods/v/SUAISchedule.svg?style=flat)](https://cocoapods.org/pods/SUAISchedule)
[![License](https://img.shields.io/cocoapods/l/SUAISchedule.svg?style=flat)](https://cocoapods.org/pods/SUAISchedule)
[![Platform](https://img.shields.io/cocoapods/p/SUAISchedule.svg?style=flat)](https://cocoapods.org/pods/SUAISchedule)
###
SUAI is a lightweight and very simple library for load schedule of groups or teachers studying in [Saint Petersburg State University of Aerospace Instrumentation](http://suai.ru).
Current version is beta, it doesn't obtain status of internet connection and not return adequate error codes.

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SUAISchedule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SUAI'
```
## Usage

Library contains SUAIManager class, which is a singleton, it means that during all program execution you will have only one instance of this class (it's necessary to load entity codes once and store it in instance).

SUAIManager have one delegate method:
```Objective-C
- (void)didChangeStatus:(Status)status;
```
Where Status is a structure which means current status of SUAIManager:
1. Ok (i.e all codes is loaded and SUAIManager can load any schedule you need);
2. Error (i.e. SUAIManager doesn't contain codes or it have problems with internet connection).

Full description of Status below:
```Objective-C
typedef enum Status {
    Ok,
    Error
}Status;
```
### Step by step
1. Import SUAIManager.h to your class:
```Objective-C
#import "SUAIManager.h"
```
2. Set delegate if you want to obtain status of SUAIManager and of course implement method in class:
```Objective-C
[SUAIManager instance].delegate = self;
```
3. Use method:
```Objective-C
- (void)loadScheduleFor:(NSString *)identificator
           ofEntityType:(Entity)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (NSString *fail))fail;
```
For getting schedule for teacher or group passed in first argument (for example, 1740M). Also you need to pass entity. In next releases may be entity will be deprecated.

### Important
Don't forget to allow arbitrary loads!
It's pretty easy:
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

SUAISchedule is available under the MIT license. See the LICENSE file for more info.
