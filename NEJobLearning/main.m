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
    NSLog(@"%s", __FUNCTION__);
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NEString __weak* str = [[NEString alloc] init];
        str = @"assigning to a pointer who's object has bean released";
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
