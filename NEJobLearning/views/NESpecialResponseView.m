//
//  NESpecialResponseView.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/30.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NESpecialResponseView.h"

@implementation NESpecialResponseView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint localPoint = [self convertPoint:point toView:self.specialView];
    //调用下列两种方法均可；关键是记得转换一下local point
//    if ([self.specialView pointInside:localPoint withEvent:event]) {
    //使用hitTest则会在系统层面调用pointInside
    if ([self.specialView hitTest:localPoint withEvent:event]) {
        return self.specialView;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
