//
//  TYLimitedTextView.m
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "TYLimitedTextView.h"

@interface TYLimitedTextView ()<UITextViewDelegate>

@end

@implementation TYLimitedTextView

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
    self.maxLength = 0;
    
    //设置基本属性
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    self.delegate = self;
}


#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //如果用户点击了return
    if([text isEqualToString:@"\n"]){
        if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextViewShouldReturn:)]) {
           return [_realDelegate limitedTextViewShouldReturn:textView];
        }
        return NO;
    }
    
    //长度限制操作
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > self.maxLength && self.maxLength){
        
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        
        if (rangeIndex.length == 1){//字数超限
            textView.text = [str substringToIndex:self.maxLength];
            //记录输入的字数
            self.inputLength = textView.text.length;
            if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextViewDidChange:)]) {
                [_realDelegate limitedTextViewDidChange:textView];
            }
            
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > self.maxLength && self.maxLength){
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
    //记录输入的字数
    self.inputLength = textView.text.length;
    
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextViewDidChange:)]) {
        [_realDelegate limitedTextViewDidChange:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextViewDidEndEditing:)]) {
        [_realDelegate limitedTextViewDidEndEditing:textView];
    }
}


@end
