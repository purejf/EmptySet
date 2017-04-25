//
//  UIScrollView+CYEmptySet.m
//  Empty
//
//  Created by Charlesyx on 2017/4/19.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "UIScrollView+CYEmptySet.h"
#import <objc/runtime.h>

@interface UIScrollView_ContentView : UIView

@end

@implementation UIScrollView_ContentView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

@end

@interface UIScrollView ()

@property (nonatomic, strong) UIScrollView_ContentView *contentView;

@end

void exchangeSelector(SEL sel1, SEL sel2, Class cls) {
    Class class = [cls class];
    Method originalMethod = class_getInstanceMethod(class, sel1);
    Method swizzledMethod = class_getInstanceMethod(class, sel2);
    BOOL success = class_addMethod(class, sel1, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, sel2, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIScrollView (CYEmptySet)

- (void)setCoverContentInset:(BOOL)cover {
    objc_setAssociatedObject(self, @selector(coverContentInset), @(cover), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)coverContentInset {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setContentView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(contentView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView_ContentView *)contentView {
    UIScrollView_ContentView *contentView = objc_getAssociatedObject(self, _cmd);
    if (!contentView) {
        contentView = [UIScrollView_ContentView new];
        contentView.backgroundColor = [UIColor clearColor];
        self.contentView = contentView;
    }
    return contentView;
}

- (void)setCustomEmptyView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(customEmptyView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)customEmptyView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyEnabled:(BOOL)enabled {
    if (enabled) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            exchangeSelector(@selector(reloadData), @selector(cy_reloadData), [self class]);
            exchangeSelector(@selector(layoutSubviews), @selector(cy_layoutSubviews), [self class]);
        });
        self.coverContentInset = true;
    }
    objc_setAssociatedObject(self, @selector(emptyEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)emptyEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)cy_reloadData {
    [self cy_reloadData];
    
    if (!self.emptyEnabled) return;
    
    NSInteger rowCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            rowCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            rowCount += [collectionView numberOfItemsInSection:section];
        }
    }
    if (!rowCount) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) {
            
            if (self.customEmptyView.superview != self.contentView && self.customEmptyView) {
                [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.contentView removeFromSuperview];
                self.contentView = nil;
            }
            if (!self.contentView.superview) {
                if (self.subviews.count > 1) {
                    [self insertSubview:self.contentView atIndex:0];
                } else {
                    [self addSubview:self.contentView];
                }
                if (self.customEmptyView) {
                    [self.contentView addSubview:self.customEmptyView];
                }
            }
            
            self.contentView.backgroundColor = self.customEmptyView.backgroundColor;
            if (self.contentView.superview) {
                [self setNeedsLayout];
                [self layoutIfNeeded];
            }
        }
    } else {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
}

- (void)cy_layoutSubviews {
    if (self.contentView.superview) {
        UIColor *color = self.backgroundColor;
        UIColor *supColor = self.superview.backgroundColor;
        self.backgroundColor = self.customEmptyView.backgroundColor;
        self.superview.backgroundColor = self.customEmptyView.backgroundColor;
        if (!self.coverContentInset) {
            self.contentView.frame = CGRectMake(0, -self.contentInset.top, self.frame.size.width, self.frame.size.height);
        } else {
            self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.contentInset.top);
        }
        self.customEmptyView.frame = self.contentView.bounds;
        self.backgroundColor = color;
        self.superview.backgroundColor = supColor;
    }
    [self cy_layoutSubviews];
}

@end
