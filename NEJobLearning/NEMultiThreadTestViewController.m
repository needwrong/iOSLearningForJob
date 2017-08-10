//
//  NEMultiThreadTestViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/8/9.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEMultiThreadTestViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface NEMultiThreadTestViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtLog;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NEMultiThreadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //死锁： EXC_BAD_INSTRUCTION
//        //企图同步将新任务放入串行队列，而此串行队列还在等待此任务完成，形成死锁
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            ;
//        });
//    });
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
    [request setHTTPBody:[@"ttttttt" dataUsingEncoding:NSUTF8StringEncoding]];
    [[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
    }] resume];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"1"); // 任务1
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"2"); // 任务2
//        });
//        NSLog(@"3"); // 任务3
//    });
//    NSLog(@"4"); // 任务4
//    while (1) {
//    }
//    NSLog(@"5"); // 任务5
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
