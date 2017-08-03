//
//  NECategoryTest.m
//  NEJobLearning
//
//  Created by neareast on 2017/8/3.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NECategoryTest.h"
#import <objc/runtime.h>

/******* Category Implementation *******/
@implementation NECategoryTest(Category)
//1. 类方法load方法和initialize
// class或category添加到运行时的时候调用，可用于在类加载期间的一些操作（改变类方法）
+ (void) load {
    NSLog(@"%s", __FUNCTION__);
}

//在类收到任意消息之前（包括init）进行一些初始化操作；此方法父类的调用先于子类
+ (void) initialize {
    NSLog(@"%s", __FUNCTION__);
}

//编译器给出提示：Category is implementing a method which will also be implemented by its primary class
- (void)methodOverrideTest {
    NSLog(@"%s", __FUNCTION__);
}

//2.1 即使参数不同，category中同名方法也会覆盖先前定义的方法（在methodlist中靠前）
- (void)methodOverrideWithParam:(NSNumber *)number {
    NSLog(@"%s", __FUNCTION__);
}
@end

@implementation NECategoryTest(OtherCategory)
//3. 只有最后一个类别(Category)的+(void)initialize执行，其他两个都被隐藏。而对于+(void)load，三个都执行
//4. 父类(Superclass)的方法优先于子类(Subclass)的方法，类中的方法优先于类别(Category)中的方法
+ (void) load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void) initialize {
    NSLog(@"%s", __FUNCTION__);
}

//2.2 返回值不同也可以覆盖方法
- (BOOL)methodOverrideTest{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
@end

@implementation NECategoryTest

#pragma mark - initialize and lifecycle
+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)init {
    NSLog(@"%s", __FUNCTION__);
    return [super init];
}

#pragma mark - overrideTest
- (void)methodOverrideTest {
    NSLog(@"%s", __FUNCTION__);
}

- (void)methodOverrideWithParam:(NSString *)str {
    NSLog(@"%s", __FUNCTION__);
}

//6.category其实并不是完全替换掉原来类的同名方法，只是category在方法列表的前面而已，所以我们只要顺着方法列表找到最后一个对应名字的方法，就可以调用原来类的方法
+ (void)callOriginMethodOfName:(NSString *)name onObject:(id)obj {
    Class currentClass = [obj class];
    
    if (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        IMP lastImp = NULL;
        SEL lastSel = NULL;
        for (NSInteger i = 0; i < methodCount; i++) {
            Method method = methodList[i];
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                                      encoding:NSUTF8StringEncoding];
            NSLog(@"found methodName: %@", methodName);
            if ([name isEqualToString:methodName]) {
                lastImp = method_getImplementation(method);
                lastSel = method_getName(method);
            }
        }
        typedef void (*fn)(id,SEL);
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(obj, lastSel);
            NSLog(@"%s success", __FUNCTION__);
        } else {
            NSLog(@"method %@ not found", name);
        }
        free(methodList);
    }
    
}

@end
