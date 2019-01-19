//
//  SUAI.m
//  SUAI
//
//  Created by Виктор on 13/12/2018.
//

#import "SUAI.h"
#import "Reachability.h"

NSString *kSUAIReachabilityNotification = @"kSUAIReachabilityNotification";

@interface SUAI() {
    SUAIScheduleProvider *_schedule;
    SUAINewsProvider     *_news;
}

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *networkReachability;
@property (assign, nonatomic, readwrite) BOOL isReachable;

@end

@implementation SUAI

+ (instancetype)instance {
    static SUAI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SUAI alloc] initPrivate];
    });
    return sharedInstance;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        _isReachable = false;
        [self p_networkListenStart];
        _schedule = [SUAIScheduleProvider instance];
        _news = [[SUAINewsProvider alloc] init];
    }
    return self;
}

- (instancetype)init {
    assert("Use instance!");
    return nil;
}

- (void)p_networkListenStart {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.guap.ru"];
    self.networkReachability = [Reachability reachabilityForInternetConnection];
    [self.networkReachability startNotifier];
    [self.hostReachability startNotifier];
}

- (void)p_reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = [notification object];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    BOOL reachable = reach.currentReachabilityStatus != 0;
    if (_isReachable != reachable) {
        _isReachable = reachable;
        NSNumber *bolNumber = [NSNumber numberWithBool:_isReachable];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSUAIReachabilityNotification object:bolNumber];
        NSLog(@"status: %d", _isReachable);
    }
}

- (SUAIScheduleProvider *)schedule {
    return _schedule;
}

- (SUAINewsProvider *)news {
    return _news;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

@end
