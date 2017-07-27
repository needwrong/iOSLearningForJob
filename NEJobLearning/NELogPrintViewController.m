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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logPrintString:(NSString *)str {
    self.txtViewLogPrint.text = [self.txtViewLogPrint.text stringByAppendingString:str];
}


@end
