//
//  CYEmptyPageView.h
//
//
//  Created by Charles on 2017/3/27.
//  Copyright © 2017年 yx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYEmptyPageView;

typedef void(^CYEmptyPageViewBtnClickHandle)(CYEmptyPageView *emptyPageView);

@interface CYEmptyPageView : UIView

// 点击按钮回调
@property (nonatomic, copy) CYEmptyPageViewBtnClickHandle handle;

// 图片
@property (nonatomic, copy) NSString *imagename;

// 文本
@property (nonatomic, copy) NSString *title;

// 按钮文本
@property (nonatomic, copy) NSString *btnTitle;

// 图片上部
@property (nonatomic, assign) CGFloat imageTop;

// 图片高度
@property (nonatomic, assign) CGFloat imgH;

// 标题顶部
@property (nonatomic, assign) CGFloat titleTop;

// 按钮顶部
@property (nonatomic, assign) CGFloat btnTop;

// 标题高度
@property (nonatomic, assign) CGFloat labelH;

// 按钮高度
@property (nonatomic, assign) CGFloat btnH;

@end
