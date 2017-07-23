//
//  StaticLibTest.m
//  StaticLibTest
//
//  Created by neareast on 2017/7/22.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "StaticLibTest.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreData/CoreData.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface StaticLibTest()

@property (nonatomic, strong) UIView *view, *view2, *view3, *view4;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) CAAnimation *anim;
@property (nonatomic, strong) NSManagedObject *obj;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation StaticLibTest

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"asd;falksdjfa");
        
        NSLog(@"asd;falksdjfa");

        NSLog(@"asd;falksdjfa");

        NSLog(@"asd;falksdjfa");

        NSLog(@"asd;falksdjfa");

        NSLog(@"asd;falksdjfa");
        NSLog(@"asd;falksdjfa");
        NSLog(@"asd;falksdjfa");
        NSLog(@"asd;falksdjfa");
        
        
        self.anim = [CAKeyframeAnimation animationWithKeyPath:@"te"];

    }
    
    return self;
}

- (void)test {
    self.jsContext = [[JSContext alloc] init];
    
    NSString *js = @"function add(a,b) {return a+b}";
    
    [self.jsContext evaluateScript:js];
    
    JSValue *n = [self.jsContext[@"add"] callWithArguments:@[@2, @3]];
    
    NSLog(@"---%@", @([n toInt32]));//---5
}

@end
