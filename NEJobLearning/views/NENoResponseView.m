//
//  NENoResponseView.m
//  NEJobLearning
//
//  Created by neareast on 2017/8/8.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NENoResponseView.h"

@implementation NENoResponseView

//此view不响应触摸事件
//设置userInteractionEnabled = NO可以达到类似效果，但是其子视图也不能响应事件了
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitTestView = [super hitTest:point withEvent:event];
//    if (hitTestView == self) {
//        hitTestView = nil;
//    }
//    return hitTestView;
//}

//不响应触摸事件之后，touch系列方法不会调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end
