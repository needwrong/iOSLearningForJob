//
//  LCILDEnlargedButton.m
//  LECInteractionLiveDirector
//
//  Created by east on 2017/3/13.
//  Copyright © 2017年 LeCloud. All rights reserved.
//

#import "LCILDEnlargedButton.h"

@implementation LCILDEnlargedButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
