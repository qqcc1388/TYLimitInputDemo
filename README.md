    项目中各个地方都会用到TextField，textField的输入也会有各种需求，各种限制，每次用到的时候要重写一遍这些限制，导致各种垃圾代码，各种重复，有一天，我终于看不下去了，于是把textField的输入限制封装成在了一起，方便后续开发使用，代码量也减少了很多，这里把封装的View提供出现，有需要的可以参考一下。demo下载地址：
    TYLimitedTextField能够快速实现以下功能(支持xib):
    1. 限制输入的字符(数字，字母，数字+字母，email等)
    2. 提供一个可以监听textField实时改变的方法，不需要自己去写观察者
    3. 限制输入文字的最大长度
    4. 限制textField距离leftPading rightPading
    5. 更方便快捷的设置leftView rightView

    话不多说了 上代码
```
///
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

```

```
//
//  TYLimitedTextField.m
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "TYLimitedTextField.h"

//字母+数字
#define kLetterNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kEmail      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"

@interface TYLimitedTextField () <UITextFieldDelegate>

//筛选条件
@property (nonatomic,copy) NSString *filter;

@end

@implementation TYLimitedTextField


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    //设置默认值
    self.rightPadding = 5;
    self.leftPadding = 5;
    self.limitedType = TYLimitedTextFieldTypeNomal;
    
    //设置边框和颜色
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.font = [UIFont systemFontOfSize:14];
    
    //设置代理 这里delegate = self 外面就不可以在使用textField的delegate 否则这个代理将会失效
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

#pragma mark - textFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldReturn:)]) {
        return [_realDelegate limitedTextFieldShouldReturn:textField];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidEndEditing:)]) {
        [_realDelegate limitedTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (!self.filter) {  return YES;}
    
    //超过最大长度 并且不是取消键被点击了
    if ((textField.text.length >= self.maxLength) && self.maxLength && ![string isEqualToString:@""]) {  return NO;}
    
    //限制条件
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:self.filter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    return  [string isEqualToString:filtered];
}

//textField内容有变化会调用这个方法
-(void)textFieldDidChange:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidChange:)]) {
        [_realDelegate limitedTextFieldDidChange:textField];
    }
}


#pragma mark - setter getter

-(void)setLimitedType:(TYLimitedTextFieldType)limitedType{
    _limitedType = limitedType;
    
    //根据Type选择键盘
    if (limitedType == TYLimitedTextFieldTypeNomal) {
        self.keyboardType = UIKeyboardTypeDefault;
        self.filter = nil;
    }else{  //限制输入这里使用自定义键盘
        self.keyboardType = UIKeyboardTypeASCIICapable;
        if (limitedType == TYLimitedTextFieldTypeNumber) {  //数字
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.filter = nil;
        }else if(limitedType == TYLimitedTextFieldTypeNumberOrLetter){  //数字和字母
            self.filter = kLetterNum;
        }else if(limitedType == TYLimitedTextFieldTypeEmail){  //email
            self.filter = kEmail;
        }
    }
}

-(void)setLeftPadding:(CGFloat)leftPadding{
    _leftPadding = leftPadding;
    [self setValue:@(leftPadding) forKey:@"paddingLeft"];
}

-(void)setRightPadding:(CGFloat)rightPadding{
    _rightPadding = rightPadding;
    [self setValue:@(rightPadding) forKey:@"paddingRight"];
}

-(void)setCustomLeftView:(UIView *)customLeftView{
    _customLeftView = customLeftView;
    self.leftView = customLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setCustomRightView:(UIView *)customRightView{
    _customRightView = customRightView;
    self.rightView = customRightView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end

```

使用起来也非常简单 需要仅仅只是需要设置限制
```
    //设置限制键盘类型
    self.textField.limitedType = TYLimitedTextFieldTypeEmail;
    
    //设置最大长度
    self.textField.maxLength = 11;
    
    //设置leftPading rightPading
    self.textField.leftPadding = 10;
    self.textField.rightPadding = 10;
    
    //设置leftView rightView
    UIButton *item = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.textField.customLeftView = item;
```
如果需要监听简单事件则需要实现代理realDelegate
```
    self.textField.realDelegate = self;

    -(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击了return");
    return YES;
    }

    -(void)limitedTextFieldDidEndEditing:(UITextField *)textField{
        NSLog(@"结束编辑 - text:%@",textField.text);
    }

    -(void)limitedTextFieldDidChange:(UITextField *)textField{
        NSLog(@"实时监听文字改变%@",textField.text);
    }
```

使用TYLimitedTextField一定要注意：TYLimitedTextField已经将系统的TextField部分代理方法拓展出来了，所有如果你需要使用TYLimitedTextField回调功能，请不要使用delegate而使用realDelegate，否则会出现冲突也就是self.delegate = self 的尴尬。如果拓展出来的方法不足以你使用，自己自行拓展。


    
    
