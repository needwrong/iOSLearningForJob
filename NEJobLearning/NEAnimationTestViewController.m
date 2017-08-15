//
//  ViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/22.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NEAnimationTestViewController.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif


@interface NEAnimationTestViewController ()

@property (nonatomic, strong) UIView *animView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation NEAnimationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //借用CADisplayLink观察属性值的实时变化
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(watchViewAction)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
//    [self animationTestBasic];
//    [self animationTestSpringGroupDynamic];
    [self UIDynamicTest];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopWatchView];
    });
}

- (void)watchViewAction {
    CALayer *presentationLayer = self.animView.layer.presentationLayer;
    CALayer *modelLayer = self.animView.layer.modelLayer;
    NSLog(@"%@&&%@", NSStringFromCGPoint(modelLayer.position), NSStringFromCGPoint(presentationLayer.position));
}

- (void)stopWatchView {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self watchViewAction];
}

- (void)animationTestBasic {
    NSAssert(!_animView, @"请一次进行一组试验");

    _animView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    _animView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_animView];
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(_animView.frame), NSStringFromCGRect(_animView.bounds));
    
    //1.CGAffineTransformMake***/CGAffineTransform***
    //    view.transform = CGAffineTransformMakeRotation(M_PI_4);
    //    view.transform = CGAffineTransformScale(view.transform, 3/2., 3/2.);
    
    //效果同transform = CGAffineTransformScale(view.transform, 3/2., 3/2.)
    //    view.bounds = CGRectMake(0, 0, 300, 300);
    //    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds));

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
    //4.1 设置fromValue很关键，否则下面设置layer的值之后，动画没了效果
    //如果已经有别的动画正在执行，我们需要从呈现图层那里去获得fromValue
    positionAnim.fromValue = [NSValue valueWithCGPoint:_animView.layer.position];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(screenSize.width / 2, screenSize.height / 2)];
    [_animView.layer addAnimation:positionAnim forKey:@"move"];
    
    //4.2 设置动画结束时layer的状态
    //4.3 如果这里的图层并不是UIView关联的图层，我们需要用CATransaction来禁用隐式动画行为，否则默认的图层行为会干扰我们的显式动画（实际上，显式动画通常会覆盖隐式动画，但为了安全最好这么做）。
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    [_animView.layer setValue:positionAnim.toValue forKey:positionAnim.keyPath];
//    [CATransaction commit];
    
    //5. 旋转之后，view的Frame与bounds的宽高可能不同
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(_animView.frame), NSStringFromCGRect(_animView.bounds));
    
    
    //6. 一个动画未结束，开启另一个动画
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.duration = 2;
    
    transformAnim.beginTime = CACurrentMediaTime() + 1;
    //立即执行动画的第一帧（未翻转状态），不论是否设置了 beginTime属性
    transformAnim.fillMode = kCAFillModeBackwards;
    
    //设置fromValue很关键，否则下面设置layer的值之后，动画没了效果
    transformAnim.fromValue = [NSValue valueWithCATransform3D:_animView.layer.transform];
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, 1)];
    [_animView.layer addAnimation:transformAnim forKey:@"rotation"];
    
    //此动画延后开启，可以延时更改model layer状态而不设置fillMode
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    [_animView.layer setValue:transformAnim.toValue forKey:transformAnim.keyPath];
//    [CATransaction commit];
    //    });
    
    NSLog(@"view: %@\nbounds: %@", NSStringFromCGRect(_animView.frame), NSStringFromCGRect(_animView.bounds));
}

- (void)animationTestSpringGroupDynamic {
    NSAssert(!_animView, @"请一次进行一组试验");
    
    _animView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 150, 150)];
    _animView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_animView];

//    //7.spring动画 更适合用于位移动画  http://www.jianshu.com/p/90a7a1787d1b
    CASpringAnimation *springAmin = [CASpringAnimation animationWithKeyPath:@"position"];
//    springAmin.beginTime = CACurrentMediaTime() + 1;
//    springAmin.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.7, .7, 1)];
    springAmin.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 400)];
    [_animView.layer addAnimation:springAmin forKey:@"move"];
    NSLog(@"%f", springAmin.duration);
    
    //使用UIView动画无需操心动画状态与modelview不一致
//    [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
//        view.center = CGPointMake(300, 400);
//    } completion:^(BOOL finished) {
//        NSLog(@"spring动画结束");
//    }];

    
    //8.keyframe动画  transitionWithView等更多UIView动画：http://www.jianshu.com/p/5abc038e4d94
    [UIView animateKeyframesWithDuration:9.0 delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:1.0 / 4 animations:^{
            _animView.backgroundColor = [UIColor colorWithRed:0.9475 green:0.1921 blue:0.1746 alpha:1.0];
        }];
        [UIView addKeyframeWithRelativeStartTime:1.0 / 4 relativeDuration:1.0 / 4 animations:^{
            _animView.backgroundColor = [UIColor colorWithRed:0.1064 green:0.6052 blue:0.0334 alpha:1.0];
        }];
        [UIView addKeyframeWithRelativeStartTime:2.0 / 4 relativeDuration:1.0 / 4 animations:^{
            _animView.backgroundColor = [UIColor colorWithRed:0.1366 green:0.3017 blue:0.8411 alpha:1.0];
        }];
        [UIView addKeyframeWithRelativeStartTime:3.0 / 4 relativeDuration:1.0 / 4 animations:^{
            _animView.backgroundColor = [UIColor colorWithRed:0.619 green:0.037 blue:0.6719 alpha:1.0];
        }];
    } completion:^(BOOL finished) {
        NSLog(@"keyframe动画结束，状态%@", finished ? @"finished" : @"unfinished");
    }];
    
    //9. 停止UIView动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALayer *pLayer = _animView.layer.presentationLayer;
        
        //9.1、删除所有动画；暴力而效果不好
//        [view.layer removeAllAnimations];
        
        //9.2、相同属性使用uiview动画
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:.001];
//        [UIView setAnimationRepeatCount:0];
//        view.backgroundColor = [UIColor colorWithCGColor:pLayer.backgroundColor];
//        [UIView commitAnimations];
        
        
        //9.3、相同属性使用uiview动画
//        [UIView animateWithDuration:0.001
//                         animations:^{
//                             //停止了上面的backgroundcolor动画
//                             view.backgroundColor = [UIColor colorWithCGColor:pLayer.backgroundColor];
//                         } completion:nil];
        //9.4、同上
//        [UIView animateWithDuration:0.001
//                              delay:0
//                            options:UIViewAnimationOptionBeginFromCurrentState
//                         animations:^{
//                              view.backgroundColor = [UIColor colorWithCGColor:pLayer.backgroundColor];
//                         } completion:nil];
        
        //9.5、同上
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.001];
        _animView.backgroundColor = [UIColor colorWithCGColor:pLayer.backgroundColor];
        [UIView commitAnimations];
        
    });
    
    //10. 动画组
    //贝塞尔曲线路径
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(10.0, 10.0)];
    [movePath addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(300, 100)];

    //关键帧动画（位置）
    CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = movePath.CGPath;

    //缩放动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];

    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:posAnim, scaleAnim, opacityAnim, nil];
    animGroup.duration = 1;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    
    [_animView.layer addAnimation:animGroup forKey:@"group"];
}

- (void)UIDynamicTest {
    NSAssert(!_animView, @"请一次进行一组试验");

    _animView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    _animView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_animView];
    
    // 1. 谁来仿真？UIDynamicAnimator来负责仿真
    static UIDynamicAnimator *animator;
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 2. 仿真个什么动作？自由落体
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_animView]];
    
    // 3. 碰撞检测
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_animView]];
//     设置不要出边界，碰到边界会被反弹
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 4. 开始仿真
    [animator addBehavior:gravity];
    [animator addBehavior:collision];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
