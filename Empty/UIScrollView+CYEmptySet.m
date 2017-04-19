//
//  UIScrollView+CYEmptySet.m
//  Empty
//
//  Created by Charlesyx on 2017/4/19.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "UIScrollView+CYEmptySet.h"
#import <objc/runtime.h>

static char CYEmptySetCustomViewKey;

static char CYEmptySetContentViewKey;

static char CYEmptySetEmptyEnabledKey;

@interface UIScrollView ()

@property (nonatomic, weak) UIView *contentView;

@end

@implementation UIScrollView (CYEmptySet)

- (void)exchangeSeletor1:(SEL)selector1 selector2:(SEL)selector2 {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, selector1);
    Method swizzledMethod = class_getInstanceMethod(class, selector2);
    
    // Change implementation
    BOOL success = class_addMethod(class, selector1, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, selector2, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setContentView:(UIView *)contentView {
    objc_setAssociatedObject(self, &CYEmptySetContentViewKey, contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)contentView {
    UIView *contentView = objc_getAssociatedObject(self, &CYEmptySetContentViewKey);
    if (!contentView) {
        contentView = [UIView new];
        contentView.backgroundColor = [UIColor clearColor];
        self.contentView = contentView;
    }
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    return contentView;
}

- (void)cy_reloadData {
    [self cy_reloadData];
    
    if (!self.emptyEnabled) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIView *contentView = self.contentView;
        
        if (![self rowCount]
            && ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]])
            && !contentView.superview
            && self.subviews.count > 1) {
            [self insertSubview:contentView atIndex:0];
            if (self.customEmptyView) {
                self.customEmptyView.translatesAutoresizingMaskIntoConstraints = false;
                [contentView addSubview:self.customEmptyView];
            }
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0.0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
            
            [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),
                                                      @(NSLayoutAttributeLeft),
                                                      @(NSLayoutAttributeBottom),
                                                      @(NSLayoutAttributeRight)] view:self.contentView equalToSuperView:self];
            [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),
                                                      @(NSLayoutAttributeLeft),
                                                      @(NSLayoutAttributeBottom),
                                                      @(NSLayoutAttributeRight)] view:self.customEmptyView equalToSuperView:self.contentView];
            
            
            
        } else {
            [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [contentView removeFromSuperview];
            contentView = nil;
        }
    });
 
}

- (void)addConstraintWithLayoutAttributes:(NSArray *)attributes view:(UIView *)view equalToSuperView:(UIView *)superView {
    if (!superView || !view) return;
    for (NSNumber *attribute in attributes) {
        NSLayoutAttribute att = attribute.integerValue;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:att
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:att
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [superView addConstraint:constraint];
    }
}

- (NSInteger)rowCount {
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
    return rowCount;
}

- (UIView *)customEmptyView {
    return objc_getAssociatedObject(self, &CYEmptySetCustomViewKey);
}

- (void)setCustomEmptyView:(UIView *)customEmptyView {
    objc_setAssociatedObject(self, &CYEmptySetCustomViewKey, customEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)emptyEnabled {
    return [objc_getAssociatedObject(self, &CYEmptySetEmptyEnabledKey) boolValue];
}

- (void)setEmptyEnabled:(BOOL)emptyEnabled {
    if (emptyEnabled) {
        [self exchangeSeletor1:@selector(reloadData) selector2:@selector(cy_reloadData)];
    }
    objc_setAssociatedObject(self, &CYEmptySetEmptyEnabledKey, @(emptyEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
