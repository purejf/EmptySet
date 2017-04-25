//
//  UIScrollView+CYEmptySet.h
//  Empty
//
//  Created by Charlesyx on 2017/4/19.
//  Copyright © 2017年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CYEmptySet)

// 空界面占位界面
@property (nonatomic, strong) UIView *customEmptyView;

// 无数据时是否展示空界面
@property (nonatomic, assign) BOOL emptyEnabled;

// 包含contentInset
@property (nonatomic, assign) BOOL coverContentInset;

// 空界面时是否允许滚动
@property (nonatomic, assign) BOOL emptyAllowScroll;

@end
