    ###项目中各个地方都会用到textField,textView，他们输入也会有各种需求，各种限制，每次用到的时候要重写一遍这些限制，导致各种垃圾代码，各种重复，有一天，我终于看不下去了，于是把他们进行了一层封装，方便后续开发使用，代码量也减少了很多，这里把封装的View提供出来，有需要的可以参考一下。

    TYLimitedTextField能够快速实现以下功能(支持xib):
    1. 限制输入的字符(数字，字母，数字+字母，email等)
    2. 提供一个可以监听textField实时改变的方法，不需要自己去写观察者
    3. 限制输入文字的最大长度
    4. 限制textField距离leftPading rightPading
    5. 更方便快捷的设置leftView rightView

    TYLimitedTextView能够快速实现功能(支持xib)
    1. placeholoder功能实现
    2. textview输入长度实时监听，控制
    3. 提供代理方法实现textview return事件回调

TYLimitedTextField  TYLimitedTextView具体代码请参考demo

**TYLimitedTextField 使用说明：**

使用起来也非常简单 如果仅仅只是需要设置限制
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


 **TYLimitedTextView 使用说明：**
 ```
     //设置允许输入的最大长度
    self.textView.maxLength = 200;

    self.textView.backgroundColor = [UIColor cyanColor];
    
    //设置placeholder
    self.textView.placeholder = @"请填写用户用户简介";
 ```

 代理方法可用来监听textView输入，return endEditing事件
```
    //设置代理方法
self.textView.realDelegate = self;

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
```

** 使用TYLimitedTextField和TYLimitedTextView一定要注意：TYLimitedTextField和YLimitedTextView已经将系统的TextField，textView部分代理方法拓展出来了，所有如果你需要使用TYLimitedTextField,TYLimitedTextView回调功能，请不要使用delegate而使用realDelegate，否则会出现冲突也就是self.delegate = self 的尴尬。如果拓展出来的方法不足以你使用，自己自行拓展。 **


    
    
