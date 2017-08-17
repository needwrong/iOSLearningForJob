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


@interface NETestBase : NSObject

@end;


@interface NECategoryTest : NETestBase {
    id privateProperty;
}

@property (nonatomic, strong) id originalProperty;

- (void)methodOverrideTest;

- (void)methodOverrideWithParam:(NSString *)str;

+ (void)callOriginMethodOfName:(NSString *)name onObject:(id)obj;

//用runtime系列方法动态添加一个属性
+ (void)addPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value;

//工具方法；打印theClass所有属性的attributes及name
+ (NSArray *)getPropertyNameList:(Class)theClass;

- (void)categoryPropertyTest:(NSString *)newValue;

@end
