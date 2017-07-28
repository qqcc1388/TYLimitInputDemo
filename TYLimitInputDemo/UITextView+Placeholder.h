//
//  UITextView+Placeholder.h
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong)   NSString *placeholder;
@property (nonatomic, strong)   NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong)   UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
