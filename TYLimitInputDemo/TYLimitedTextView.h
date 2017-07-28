//
//  TYLimitedTextView.h
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TYLimitedTextViewDelegate <NSObject>

@optional


/**
 textView 键盘return事件监听

 @param textView textView
 */
-(BOOL)limitedTextViewShouldReturn:(UITextView *)textView;


/**
 textView内容改变实时监听

 @param textView textView
 */
- (void)limitedTextViewDidChange:(UITextView *)textView;


/**
 textView end editing

 @param textView textView
 */
- (void)limitedTextViewDidEndEditing:(UITextView *)textView;

@end


@interface TYLimitedTextView : UITextView


@property (nonatomic,weak) id <TYLimitedTextViewDelegate> realDelegate;

/**
 TYLimitedTextView允许输入的最大长度 默认 0不限制
 */
@property (nonatomic,assign) NSInteger maxLength;

/**
 输入内容长度
 */
@property (nonatomic,assign) NSInteger inputLength;

@end
