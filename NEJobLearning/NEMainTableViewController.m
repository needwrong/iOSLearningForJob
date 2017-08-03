//
//  NEMainTableViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/25.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEMainTableViewController.h"
#import "NETableViewTestViewController.h"
#import "NECategoryTest.h"


//1. 全局变量，可以在任意类中通过extern关键字访问修改
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

@implementation NEMainTableViewController

#pragma mark - vc life circle
//2.用于自定义self.View
- (void)loadView {
    NSLog(@"%s", __FUNCTION__);
    [super loadView];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [self globalStringTest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self categoryOverrideTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - inner method
- (void)memoryOfCopyTest {
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

- (void)categoryOverrideTest {
    NECategoryTest *categoryTest = [[NECategoryTest alloc] init];
    [categoryTest methodOverrideTest];
    [categoryTest methodOverrideWithParam:@"methodOverrideWithParam"];
    [NECategoryTest callOriginMethodOfName:@"methodOverrideTest" onObject:categoryTest];
}

- (void)globalStringTest {
    constStr = @"constStr";
    //报错；只能在声明的时候初始化
    //        constStrP = @"constStrP";
    
    //3. 其他模块可以通过extern引用并修改本模块定义的全局变量
    NSLog(@"[%p]globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]constStrP: %@\n", constStrP, constStrP);
    NSLog(@"[%p]staticStr: %@\n", staticStr, staticStr);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.row) {
        NETableViewTestViewController *tableViewTestVC = [[NETableViewTestViewController alloc] init];
        [self.navigationController pushViewController:tableViewTestVC animated:YES];
    }
}

@end
