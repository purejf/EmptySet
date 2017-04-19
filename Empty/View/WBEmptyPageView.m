//
//  WBEmptyPageView.m
//  imbangbang
//
//  Created by Charles on 2017/3/27.
//  Copyright © 2017年 com.58. All rights reserved.
//

#import "WBEmptyPageView.h"

@interface WBEmptyPageView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@end

@implementation WBEmptyPageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 1.0;
    self.button.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    self.button.layer.borderColor = [UIColor colorWithHue:0.06 saturation:0.85 brightness:1.00 alpha:1.00].CGColor;
}

- (IBAction)buttonClick:(id)sender {
    !_handle ?: _handle(self);
}

- (void)setBtnH:(CGFloat)btnH {
    _btnH = btnH;
    self.btnHeight.constant = btnH;
}

- (void)setImageTop:(CGFloat)imageTop {
    _imageTop = imageTop;
    self.imgTopMargin.constant = imageTop;
}

- (void)setImgH:(CGFloat)imgH {
    _imgH = imgH;
    self.imgHeight.constant = imgH;
}

- (void)setTitleTop:(CGFloat)titleTop {
    _titleTop = titleTop;
    self.titleLTopMargin.constant = titleTop;
}

- (void)setBtnTop:(CGFloat)btnTop {
    _btnTop = btnTop;
    self.buttonTopMargin.constant = btnTop;
}

- (void)setLabelH:(CGFloat)labelH {
    _labelH = labelH;
    self.labelHeight.constant = labelH;
}

- (void)setImagename:(NSString *)imagename {
    _imagename = imagename;
    if (!imagename.length) {
        self.imgView.hidden = YES;
        self.imgHeight.constant = 50;
        return;
    }
    self.imgView.hidden = NO;
    self.imgView.image = [UIImage imageNamed:imagename];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (!_title.length) {
        self.titleL.hidden = YES;
        self.titleLTopMargin.constant = 0;
        self.labelHeight.constant = 0;
        return;
    } 
    self.titleL.hidden = NO;
    self.titleL.text = title;
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    if (!_btnTitle.length) {
        self.button.hidden = YES;
        return;
    }
    self.button.hidden = NO;
    [self.button setTitle:btnTitle forState:UIControlStateNormal];
}

// 判断点击位置是否和按钮有重合
- (BOOL)buttonIntersectsWithTouchPoint:(CGPoint)touchPoint {
    CGRect buttonF = self.button.frame;
    CGFloat buttonXFrom = buttonF.origin.x;
    CGFloat buttonXEnd = buttonF.origin.x + buttonF.size.width;
    CGFloat buttonYFrom = buttonF.origin.y;
    CGFloat buttonYEnd = buttonF.origin.y + buttonF.size.height;
    
    CGFloat touchX = touchPoint.x;
    CGFloat touchY = touchPoint.y;
    if (touchX > buttonXFrom && touchX < buttonXEnd && touchY > buttonYFrom && touchY < buttonYEnd) {
        return YES;
    }
    return NO;
}

@end
