//
//  NEAutolayoutScrollViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/8/26.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEAutolayoutScrollViewController.h"
#import "NETouchDrawView.h"

#pragma mark - NEScrollView

@interface NEScrollView : UIScrollView

@end

@implementation NEScrollView

#pragma mark - UIGestureRecognizerDelegate
//UIScrollView's built-in pan gesture recognizer must have its scroll view as its delegate.
//所以只能在scrollView的子类中重写PanGestureRecognizer的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *view = [touch view];
    //当NETouchDrawView的父视图是此UIScrollView时，使滑动手势不生效，以免中断绘图所依赖的touch事件
    if ([view isKindOfClass:[NETouchDrawView class]]) {
        return NO;
        //打开下列注释，则只要触摸起点在UIButton上，无论长按还是短按，scrollView都不会滚动
    } else if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end


#pragma mark - NEAutolayoutScrollViewController

@interface NEAutolayoutScrollViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NEAutolayoutScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBtnOnScrollViewClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"button on scrollview clicked !" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
