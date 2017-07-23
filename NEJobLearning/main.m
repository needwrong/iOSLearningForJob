//
//  main.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/22.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NEString : NSString

@end

@implementation NEString

- (void)dealloc {
    NSLog(@"asdf");
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NEString __weak* str = [[NEString alloc] init];
        str = @"asdf";
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
