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


@interface NECategoryTest(otherCategory)

//13.1 category中添加属性的简便方法；如果不指定getter，默认getter方法名是strInCategory
//！category中添加属性对类的ivar及property没有影响；也默认没有对应的method
@property (nonatomic, strong, getter=getStrInCategory) NSString *strInCategory;

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
//- (BOOL)methodOverrideTest{
//    NSLog(@"%s", __FUNCTION__);
//    return YES;
//}

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

#pragma mark - 用runtime系列方法添加property（借助static变量存储示例）
//在目标target上添加属性，属性名propertyname，值value
+ (void)addPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value {
    /***********************  为便于分析类结构体的变化，下面进行一系列取值操作  ***********************/
    __block unsigned int outCount = 0;
    __block unsigned int outCountMethod = 0;
    __block unsigned int outCountProperty = 0;
    __block Ivar *ivars = class_copyIvarList([target class], &outCount);
    __block Method *methods = class_copyMethodList([target class], &outCountMethod);
    __block objc_property_t *properties = class_copyPropertyList([target class], &outCountProperty);
    NSLog(@"before add property, we have %d ivars, %d methods, %d properties", outCount, outCountMethod, outCountProperty);
    //7. @interface或@implementation紧接着大括号定义的私有变量不自动生成getter/setter方法，直接放入ivar列表不改名
    //ivar_getName(ivars[0])的值 "privateProperty"

    //8. 类中用property定义的属性存在于property及ivar（前面加下划线）中；并且默认生成对应的getter/setter方法
    //ivar_getName(ivars[1])的值"_originalProperty"
    //property_getName(properties[0])的值 "originalProperty"
    /***********************  ***************************************  ***********************/

    
    //先判断有没有这个属性，没有就添加，有就直接赋值
    //iVar就是InstanceVariable
    Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return;
    }
    
    /*
     objc_property_attribute_t type = { "T", "@\"NSString\"" };
     objc_property_attribute_t ownership = { "C", "" }; // C = copy
     objc_property_attribute_t backingivar  = { "V", "_privateName" };
     objc_property_attribute_t attrs[] = { type, ownership, backingivar };
     class_addProperty([SomeClass class], "name", attrs, 3);
     */
    
    //objc_property_attribute_t所代表的意思可以调用getPropertyNameList打印，大概就能猜出 ?
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])] UTF8String] };
    objc_property_attribute_t ownership = { "&", "N" };
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    
    //9. 只能添加property，ivar列表不会改变
    if (class_addProperty([target class], [propertyName UTF8String], attrs, 3)) {
        //添加get和set方法
        //10. 新增加的方法位于method list的前面，即methods[0]
        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        
        ivars = class_copyIvarList([target class], &outCount);
        methods = class_copyMethodList([target class], &outCountMethod);
        properties = class_copyPropertyList([target class], &outCountProperty);
        NSLog(@"after add property, we have %d ivars, %d methods, %d properties", outCount, outCountMethod, outCountProperty);

        //11. 赋值；调用setter方法
        [target setValue:value forKey:propertyName];
        NSLog(@"创建属性Property成功");
    } else {
        class_replaceProperty([target class], [propertyName UTF8String], attrs, 3);
        //添加get和set方法
        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        //赋值
        [target setValue:value forKey:propertyName];
    }
}

id getter(id self1, SEL _cmd1) {
    //12.1 动态添加的property，需借用ivar或static变量来存取属性的值
//    NSString *key = NSStringFromSelector(_cmd1);
//    objc_property_t property = class_getProperty([self1 class], [key UTF8String]);
//    Ivar ivar = class_getInstanceVariable([self1 class], [key UTF8String]);
    
    return propertyString;
}

static NSString *propertyString;
void setter(id self1, SEL _cmd1, id newValue) {
    //12.2 动态添加的property，需借用ivar或static变量来存取属性的值
    //http://www.cnblogs.com/feng9exe/p/6040970.html   此文有借用Ivar字典变量的示例，如有需要请参阅
//    NSString *key = [NSStringFromSelector(_cmd1) stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
//    key = [key lowercaseString];
//    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
//    Ivar ivar = class_getInstanceVariable([self1 class], [key UTF8String]);
//    object_setIvar(self1, ivar, newValue);
    
    propertyString = newValue;
}

#pragma mark - category中添加属性，借助associatedObject及静态变量；写法上比runtime系列方法简便
- (void)categoryPropertyTest:(NSString *)newValue {
    NSLog(@"categoryProperty value: %@", self.strInCategory);
    self.strInCategory = newValue;
    NSLog(@"categoryProperty value after set: %@", self.strInCategory);

}

//13.2 搭配category中的属性，必须实现下列对应的存取方法，否则使用属性时崩溃
- (NSString *)getStrInCategory {
    return (NSString *)objc_getAssociatedObject(self, @"strInCategory");
}

- (void)setStrInCategory:(NSString *)strInCategory {
    //13.3 第3个参数传入nil值即可清除association
    objc_setAssociatedObject(self, @"strInCategory", strInCategory, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
