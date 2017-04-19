//
//  UIScrollView+CYEmptySet.h
//  Empty
//
//  Created by Charlesyx on 2017/4/19.
//  Copyright © 2017年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CYEmptySet)

@property (nonatomic, weak) UIView *customEmptyView;

@property (nonatomic, assign) BOOL emptyEnabled;

@end
