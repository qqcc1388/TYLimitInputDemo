//
//  TYLimitedTextField.h
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TYLimitedTextFieldType) {
    
    TYLimitedTextFieldTypeNomal = 0,
    TYLimitedTextFieldTypeNumber,           //数字
    TYLimitedTextFieldTypeNumberOrLetter,   //数字和字母
    TYLimitedTextFieldTypeEmail,            //数字 字母 和 特定字符( '.'  '@')
};


@class TYLimitedTextField;

@protocol TYLimitedTextFieldDelegate <NSObject>

//为了防止 self.delegate = self 然后外部有重写了这个delegate方法导致代理失效的问题，这里重写一遍系统的代理方法
//在使用TYLimitedTextField的使用请不要使用UITextField本身代理方法
@optional     //   ----这里只是拓展了textField的部分代理，如果有需要还可以自己实现在这里添加

/**
 键盘return键点击调用
 
 @param textField TYLimitedTextField
 */
-(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField;

/**
 输入结束调用
 
 @param textField TYLimitedTextField
 */
-(void)limitedTextFieldDidEndEditing:(UITextField *)textField;

/**
 输入内容改变调用(实时变化)

 @param textField TYLimitedTextField
 */
-(void)limitedTextFieldDidChange:(UITextField *)textField;

@end


@interface TYLimitedTextField : UITextField

/**
 代理方法 尽量使用这个代理而不是用textfield的代理
 */
@property (nonatomic,weak) id<TYLimitedTextFieldDelegate> realDelegate;

/**
 TYLimitedTextFieldType 根据type值不同 给出不同limited 默认TYLimitedTextFieldTypeNomal
 */
@property (nonatomic,assign) TYLimitedTextFieldType limitedType;

/**
 textField允许输入的最大长度 默认 0不限制
 */
@property (nonatomic,assign) NSInteger maxLength;

/**
 距离左边的间距  默认0
 */
@property (nonatomic,assign) CGFloat leftPadding;

/**
 距离右边的间距 默认 0
 */
@property (nonatomic,assign) CGFloat rightPadding;

/**
 textField -> leftView
 */
@property (nonatomic,strong) UIView *customLeftView;

/**
 textField -> rightView
 */
@property (nonatomic,strong) UIView *customRightView;

@end
