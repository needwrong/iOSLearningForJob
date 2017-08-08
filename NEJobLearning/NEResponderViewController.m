//
//  NEResponderViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/30.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEResponderViewController.h"
#import "NESpecialResponseView.h"

@interface NEResponderViewController ()

@property (weak, nonatomic) IBOutlet NESpecialResponseView *viewSpecialResponse;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation NEResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.viewSpecialResponse.specialView = self.btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"button clicked" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
