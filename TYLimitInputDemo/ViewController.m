//
//  ViewController.m
//  TYLimitInputDemo
//
//  Created by Tiny on 2017/7/28.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "ViewController.h"
#import "TYLimitedTextField.h"

@interface ViewController ()<TYLimitedTextFieldDelegate>

@property (weak, nonatomic) IBOutlet TYLimitedTextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    //如果需要监听事件 则需要设置代理
    self.textField.realDelegate = self;
    
}


#pragma mark - delegate
-(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击了return");
    return YES;
}

-(void)limitedTextFieldDidChange:(UITextField *)textField{
    NSLog(@"文字改变了%@",textField.text);
}

-(void)limitedTextFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑 - text:%@",textField.text);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
