//
//  NESpecialResponseView.h
//  NEJobLearning
//
//  Created by neareast on 2017/7/30.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NESpecialResponseView : UIView

//当前View的specialView子视图直接响应点击事件，而不论其是否被父view遮挡
@property(nonatomic, strong) UIView *specialView;

@end
