//
//  NEMainTableViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/25.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEMainTableViewController.h"
#import "NETableViewTestViewController.h"
#import <objc/runtime.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface NEMainTableViewController ()

@end

/******* Category Implementation *******/
@implementation NEMainTableViewController(Category)
+ (void) load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void) initialize {
    NSLog(@"%s", __FUNCTION__);
}

- (void)methodOverrideTest{
    NSLog(@"%s", __FUNCTION__);
}

//1.参数不同，也会覆盖方法
- (void)methodOverrideWithParam:(NSNumber *)number {
    NSLog(@"%s", __FUNCTION__);
}
@end

@implementation NEMainTableViewController(OtherCategory)
//2.只有最后一个类别(Category)的+(void)initialize执行，其他两个都被隐藏。而对于+(void)load，三个都执行
//3.父类(Superclass)的方法优先于子类(Subclass)的方法，类中的方法优先于类别(Category)中的方法
+ (void) load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void) initialize {
    NSLog(@"%s", __FUNCTION__);
}

//4.返回值不同也可以覆盖方法
- (BOOL)methodOverrideTest{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
@end

#pragma mark - NEMainTableViewController
@implementation NEMainTableViewController

#pragma mark - initialize and lifecycle
+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __FUNCTION__);
    return [super initWithCoder:aDecoder];
}

//5.用于自定义self.View
- (void)loadView {
    NSLog(@"%s", __FUNCTION__);
    [super loadView];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self methodOverrideTest];
//    [self methodOverrideWithParam:@"sdf"];
    [self callOriginMethodOfName:@"methodOverrideTest" onObject:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - overrideTest
- (void)methodOverrideTest{
    NSLog(@"%s", __FUNCTION__);
}

- (void)methodOverrideWithParam:(NSString *)str {
    NSLog(@"%s", __FUNCTION__);
}

//6.category其实并不是完全替换掉原来类的同名方法，只是category在方法列表的前面而已，所以我们只要顺着方法列表找到最后一个对应名字的方法，就可以调用原来类的方法
- (void)callOriginMethodOfName:(NSString *)name onObject:(id)obj {
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
            NSLog(@"methodName: %@", methodName);
            if ([name isEqualToString:methodName]) {
                lastImp = method_getImplementation(method);
                lastSel = method_getName(method);
            }
        }
        typedef void (*fn)(id,SEL);
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(obj, lastSel);
        }
        free(methodList);
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.row) {
        NETableViewTestViewController *tableViewTestVC = [[NETableViewTestViewController alloc] init];
        [self.navigationController pushViewController:tableViewTestVC animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
