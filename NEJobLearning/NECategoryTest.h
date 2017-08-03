//
//  NECategoryTest.h
//  NEJobLearning
//
//  Created by neareast on 2017/8/3.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface NECategoryTest : NSObject

- (void)methodOverrideTest;

- (void)methodOverrideWithParam:(NSString *)str;

+ (void)callOriginMethodOfName:(NSString *)name onObject:(id)obj;

@end
