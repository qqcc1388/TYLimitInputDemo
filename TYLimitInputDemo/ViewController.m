//
//  ViewController.m
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "ViewController.h"
#import "TYLimitedTextField.h"
#import "TYLimitedTextView.h"
#import "UITextView+Placeholder.h"

@interface ViewController ()<TYLimitedTextFieldDelegate,TYLimitedTextViewDelegate>

@property (weak, nonatomic) IBOutlet TYLimitedTextField *textField;
@property (weak, nonatomic) IBOutlet TYLimitedTextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *countLb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupTextField];
    
    [self setupTextView];
    
}

-(void)setupTextView{
    
    //设置允许输入的最大长度
    self.textView.maxLength = 200;
    
    //设置代理方法
    self.textView.realDelegate = self;
    
    self.textView.backgroundColor = [UIColor cyanColor];
    
    //设置placeholder
    self.textView.placeholder = @"请填写用户用户简介";
}

-(void)setupTextField{
    //设置限制键盘类型
    self.textField.limitedType = TYLimitedTextFieldTypeEmail;
    
    //设置最大长度
    self.textField.maxLength = 11;
    
    //设置leftPading rightPading
    self.textField.leftPadding = 10;
    self.textField.rightPadding = 10;
    
    //设置placehoder  注意顺序性 先设置文字再设置颜色
    self.textField.placeholder = @"请开始你的表演";
    self.textField.placeholderColor = [UIColor redColor];
    
    //设置leftView rightView
    UIButton *item = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.textField.customLeftView = item;
    
    //如果需要监听事件 则需要设置代理
    self.textField.realDelegate = self;
}

#pragma mark - TYLimitedTextViewDelegate
-(BOOL)limitedTextViewShouldReturn:(UITextView *)textView{
    NSLog(@"点击了return");
    return NO;
}

-(void)limitedTextViewDidChange:(UITextView *)textView{
    NSLog(@"文字改变了 -- %@",textView.text);
    self.countLb.text = [NSString stringWithFormat:@"%zi/%zi",self.textView.inputLength,self.textView.maxLength];
}

-(void)limitedTextViewDidEndEditing:(UITextView *)textView{
    NSLog(@"结束编辑 - text:%@",textView.text);
}

#pragma mark - TYLimitedTextFieldDelegate
-(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击了return");
    return NO;
}

-(void)limitedTextFieldDidChange:(UITextField *)textField{
    NSLog(@"文字改变了 -- %@",textField.text);
}

-(void)limitedTextFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑 - text:%@",textField.text);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
