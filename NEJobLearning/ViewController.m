//
//  ViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/22.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));
    
    //1.CGAffineTransformMake***/CGAffineTransform***
//    view.transform = CGAffineTransformMakeRotation(M_PI_4);
//    view.transform = CGAffineTransformScale(view.transform, 3/2., 3/2.);
    //2.效果同上；隐式动画被禁用;UIView对应layer的delegete就是这个UIView
//    view.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
    //3.不删除动画、动画fillmode前置
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    anim.duration = 1;
//    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4 * 2.5, 0, 0, 1)];
////    anim.autoreverses = YES;//动画结束后原路、原参数返回;否则的话默认原路闪回
//    anim.fillMode = kCAFillModeForwards;
//    anim.removedOnCompletion = NO;
//    [view.layer addAnimation:anim forKey:@"rotation"];
    
    //4.默认动画结束后移除动画；动画fillmode不变
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.duration = 3;
    //设置fromValue很关键，否则下面设置layer的值之后，动画没了效果
    positionAnim.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(screenSize.width / 2, screenSize.height / 2)];
    [view.layer addAnimation:positionAnim forKey:@"move"];
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [view.layer setValue:positionAnim.toValue forKey:positionAnim.keyPath];
    [CATransaction commit];
    
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));
    
    
    
    //5.一个动画未结束，开启另一个动画
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.duration = 2;
    
    transformAnim.beginTime = CACurrentMediaTime() + 1;
    //立即执行动画的第一帧（未翻转状态），不论是否设置了 beginTime属性
    transformAnim.fillMode = kCAFillModeBackwards;

    //设置fromValue很关键，否则下面设置layer的值之后，动画没了效果
    transformAnim.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, 1)];
    [view.layer addAnimation:transformAnim forKey:@"rotation"];
    
    //此动画延后开启，可以延时更改model layer状态而不设置fillMode
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [view.layer setValue:transformAnim.toValue forKey:transformAnim.keyPath];
        [CATransaction commit];
//    });
    
    
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));

    
    //TODO: 设置removeOnCompletion = NO及fillMode与否，动画都是从fromValue开始
    
    //效果同transform = CGAffineTransformScale(view.transform, 3/2., 3/2.)
//    view.bounds = CGRectMake(0, 0, 300, 300);
//    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
