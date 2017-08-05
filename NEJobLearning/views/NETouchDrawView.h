//
//  NETouchDrawView.h
//  NEJobLearning
//
//  Created by east on 2017/8/5.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELineWrap.h"

@interface NETouchDrawView : UIView

@property (nonatomic, strong) NELineWrap *currentLine;
@property (nonatomic, strong) NSMutableArray *lineList;
@property (nonatomic, strong) IBInspectable UIColor *currentColor;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

@end
