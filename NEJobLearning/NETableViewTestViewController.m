//
//  NETableViewTestViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/24.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NETableViewTestViewController.h"

#define kCellIdentifier @"cellIdentifier"

@interface NETableViewTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NETableViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //此方法居然傻傻执行100次；如果其中再调用cellForRowAtIndexPath，性能损耗可想而知
    NSLog(@"heightForRowAtIndexPath %zd", indexPath.row);
    return 100;
}


#pragma mark - UITableViewDataSource
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        cell.textLabel.text = [NSString stringWithFormat:@"row %zd", indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
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
