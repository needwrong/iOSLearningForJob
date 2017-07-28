//
//  NELogPrintViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/27.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NELogPrintViewController.h"

#define NEPrintLog 1
#define NSLog(FORMAT, ...) [self logPrintString:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]]

extern NSString *globalStr;
extern NSString *constStr;
extern NSString *constStrP;

@interface NELogPrintViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtViewLogPrint;
@property (nonatomic, copy) void(^mBlock)();

@end

@implementation NELogPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"[%p]globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]constStrP: %@\n", constStrP, constStrP);
    globalStr = @"new globalStr";
    constStr = @"new constStr";
    //如果不是NSString，其他类型强行赋值会崩溃；所以extern的声明应与原变量保持完全一致，以免不必要的后果
    constStrP = @"new constStrP";;

    
    NSLog(@"[%p]new globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]new constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]new constStrP: %@\n", constStrP, constStrP);
    // Do any additional setup after loading the view.
    
    
    NSLog(@"--------------block test-------------------\n");
    //1 __NSGlobalBlock__  全局block   存储在代码区（存储方法或者函数）
    void(^myBlock1)() = ^() {
        NSLog(@"我是老大");
    };
    NSLog(@"%@\n",myBlock1);
    
    //2 __NSStackBlock__  栈block  存储在栈区
    //block内部访问外部变量
    //block的本质是一个结构体
    int n = 5;
    void(^myBlock2)() = ^() {
        NSLog(@"我是老二%d", n);
    };
    NSLog(@"%@\n", myBlock2);
    
    
    //3 __NSMallocBlock__  堆block 存储在堆区  对栈block做一次copy操作
    void(^myBlock3)() = ^() {
        NSLog(@"我是老三%d", n);
    };
    NSLog(@"%@\n", [myBlock3 copy]);
    
    
    /*
     
     由以上三个例子可以看出当block没有访问外界的变量时,是存储在代码区,
     当block访问外界变量时时存储在栈区, 而此时的block出了作用域就会被释放
     以下示例:
     */
    [self blockTest];//当此代码结束时,blockTest函数中的所有存储在栈区的变量都会被系统释放, 因此如果属性的block是用assign修饰时,当再次访问时就会出现野指针访问.
    self.mBlock();
}

- (void)blockTest {
    int n = 5;
    __weak typeof(self) weakSelf = self;
    [self setMBlock:^{
        [weakSelf logPrintString:[NSString stringWithFormat:@"%d",n]];;
    }];
    NSLog(@"test--%@\n",self.mBlock);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logPrintString:(NSString *)str {
    self.txtViewLogPrint.text = [self.txtViewLogPrint.text stringByAppendingString:str];
}


@end
