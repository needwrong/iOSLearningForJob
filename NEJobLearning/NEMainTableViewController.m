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

//全局变量，可以在任意类中通过extern关键字访问修改
NSString *globalStr  = @"globalStr";
/* const 将修饰离它最近的对象
 “以 * 分界，把一个声明从右向左读”。
 * 读作 pointer to (指向...的指针)，const (常量) 是形容词，char (变量类型) 和 p (变量名) 当然都是名词。
 1)  const char *p 读作：p is a pointer to a const char，译：p 是一个指针(变量)，它指向一个常量字符(const char)。
 2)  char *const p 读作：p is a const pointer to a char，译：p 是一个常量指针(const p)，它指向一个字符(变量)。
 */
//全局常量；不能在当前类修改，只能在声明的时候初始化；但可以在其他类中通过extern关键字访问修改
NSString *const constStrP = @"constStrP";
const NSString *constStr;// = @"constStr";
//静态变量，只能在当前类中访问和修改
static NSString *staticStr = @"staticStr";


@interface NEMainTableViewController ()

@end

/******* Category Implementation *******/
@implementation NEMainTableViewController(Category)
+ (void) load {
    constStr = @"constStr";
    //报错；只能在声明的时候初始化
//    constStrP = @"constStrP";
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

- (void)viewDidAppear:(BOOL)animated {
    //7. 其他模块可以通过extern引用并修改本模块定义的全局变量
    NSLog(@"[%p]globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]constStrP: %@\n", constStrP, constStrP);
    NSLog(@"[%p]staticStr: %@\n", staticStr, staticStr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self methodOverrideTest];
//    [self methodOverrideWithParam:@"sdf"];
    [self callOriginMethodOfName:@"methodOverrideTest" onObject:self];
    
    
    NSString *str = @"__NSCFConstantString";
    //1. copy的NSString地址（9位）与原String相同
    NSString *cp = [str copy];
    NSLog(@"str: \n%p\n%p", str, cp);
    
    
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"__NSCFString"];
    //2. copy的NSString地址（9位）与原MutableString地址（12位）不同；mutableCopy的地址（12位）与原MutableString（12位）显然不同
    NSMutableString *mcp = [mstr mutableCopy];
    NSLog(@"mstr: \n%p\n%p", mstr, mcp);
    
    
    //3. copy的非string对象与原对象相同；若原对象为Mutable则不同
    NSArray *arr = @[@(1), [NSMutableString stringWithFormat:@"3"], @(5)];
    NSArray *copyArr = [arr copy];
    NSMutableArray *mcopyArr = [arr mutableCopy];
    NSLog(@"arr: \n%p\n%p\n%p", arr, copyArr, mcopyArr);
    
    mcopyArr[1] = @"0";
    for (id obj in mcopyArr) {
        NSLog(@"%@", [obj class]);
    }
    NSLog(@"arr:%@, copyArr:%@, mcopyArr:%@",arr, copyArr, mcopyArr);
    
    
    //4. 内存区域分布 http://www.jianshu.com/p/3b07f92d44ca
    //在32位、64位机型结果不同；iPhone5模拟器3、5、6相同
//    NSString* str1 = @"123";
//    NSLog(@"str1 = %p, str1 = %@",str1,str1);//9位地址
//    NSString* str2 = @"123";
//    NSLog(@"str2 = %p, str2 = %@",str2,str2);
//    
//    NSString* str3 = [[NSString alloc]initWithFormat:@"123"];
//    NSLog(@"str3 = %p, str3 = %@",str3,str3);//16位地址
//    NSString* str4 = [[NSString alloc]initWithFormat:@"123"];
//    NSLog(@"str4 = %p, str4 = %@",str4,str4);
//    
//    NSString* str5 = [[NSString alloc]initWithString:str3];
//    NSLog(@"str5 = %p, str5 = %@",str5,str5);//12位地址
//    NSString* str6 = [[NSString alloc]initWithString:str3];
//    NSLog(@"str6 = %p, str6 = %@",str6,str6);
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
