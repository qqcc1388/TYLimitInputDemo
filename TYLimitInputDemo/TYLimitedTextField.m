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
#define kPassword   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

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
    self.rightPadding = 10;
    self.leftPadding = 10;
    self.limitedType = TYLimitedTextFieldTypeNomal;
    self.textAlignment = NSTextAlignmentLeft;
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidBeginEditing:)]) {
        return [_realDelegate limitedTextFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidEndEditing:)]) {
        [_realDelegate limitedTextFieldDidEndEditing:textField];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldBeginEditing:)]) {
        return [_realDelegate limitedTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //超过最大长度 并且不是取消键被点击了
    if ((textField.text.length >= self.maxLength) && self.maxLength && ![string isEqualToString:@""]) {  return NO;}
    
    if (!self.filter) {  return YES;}
    
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
    if(self.textFieldDidChange){
        self.textFieldDidChange(textField.text);
    }
    if(self.textFieldDidChange){
        self.textFieldDidChange(textField.text);
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
        }else if(limitedType == TYLimitedTextFieldTypePassword){ //密码 数字 字母 下划线组成
            self.filter = kPassword;
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

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
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

//iOS11之后placeholder设置偏移后placeholder位置没有变化
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    if (@available(iOS 11.0, *)) {
        //如果是左对齐 则+leftPadding
        //右对齐      则-rightPadding
        //中间对其    则pading设置为0
        CGFloat padding = 0;
        if(self.textAlignment == NSTextAlignmentRight){
            padding = -_rightPadding;
        }else if(self.textAlignment == NSTextAlignmentLeft){
            padding = _leftPadding;
        }
        CGRect rect = {{bounds.origin.x+padding,bounds.origin.y},bounds.size};
        return [super placeholderRectForBounds:rect];
    }
    return  [super placeholderRectForBounds:bounds];
}

@end
