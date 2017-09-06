//
//  ViewController.m
//  SJJavascriptCoreDemo
//
//  Created by SDPMobile on 2017/9/6.
//  Copyright © 2017年 SoulJa. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载WebView
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [_webView setDelegate:self];
}


#pragma mark - 获取JS中定义的变量
- (void)getJSVar {
    //JS代码
    NSString *jsCode = @"var arr = [1,2,3];";
    
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 执行JS代码
    [context evaluateScript:jsCode];
    
    //获取JS的值
    JSValue *jsArr = context[@"arr"];
    
    NSLog(@"%@",jsArr);
}

#pragma mark - 调用JS的方法
- (void)getJSFunc {
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 获取JS方法，只有先执行JS代码，才能获取
    JSValue *hello = context[@"hello"];
    
    // OC调用JS方法，获取方法返回值
    JSValue *value = [hello callWithArguments:@[@"你好，SoulJa"]];
    
    NSLog(@"%@",[value toString]);
}

#pragma mark - JS调用OC中不带参数的block
- (void)jsCallOCBlock1WithNoneArguments {
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // JS调用Block方式
    // 由于JS本身没有OC这个代码，需要给JS中赋值，就会自动生成右边的代码.
    // 相当于在JS中定义一个叫eat的方法，eat的实现就是block中的实现，只要调用eat,就会调用block
    context[@"eat"] = ^(){
        NSLog(@"吃东西");
    };
}

#pragma mark - JS调用OC中带参数的block
- (void)jsCallOCBlockWithArguments {
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 2.调用带有参数的block
    // 还是一样的写法，会在JS中生成eat方法，只不过通过[JSContext currentArguments]获取JS执行方法时的参数
    context[@"run"] = ^() {
        NSArray *arguments = [JSContext currentArguments];
        NSLog(@"%@",[arguments[0] toString]);
    };
}

#pragma mark - JS调用OC自定义类
- (void)jsCallOCCustomClass
{
    // 创建Person对象
    Person *p = [[Person alloc] init];
    p.name = @"SoulJa";
    
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 会在JS中生成Person对象，并且拥有所有值
    // 前提：Person对象必须遵守JSExport协议，
    context[@"person"] = p;
    
    // 执行JS代码
    // 注意：这里的person一定要跟上面声明的一样，因为生成的对象是用person引用
    // NSString *jsCode = @"person.play()";
    NSString *jsCode = @"person.playGame('德州扑克','晚上')";
    
    [context evaluateScript:jsCode];
    
}

#pragma mark - JS调用OC系统类
- (void)jsCallOCSystemClass {
    // 给系统类添加协议
    class_addProtocol([UILabel class], @protocol(UILabelJSExport));
    // 创建UILabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [self.view addSubview:label];
    //JS上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 就会在JS中生成label对象，并且用laebl引用
    context[@"label"] = label;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //获取JS中定义的变量
    [self getJSVar];
    
    //调用JS的方法
    [self getJSFunc];
    
    //JS调用OC中不带参数的block
    [self jsCallOCBlock1WithNoneArguments];
    
    //JS调用OC中带参数的block
    [self jsCallOCBlockWithArguments];
    
    //JS调用OC自定义类
    [self jsCallOCCustomClass];
    
    //JS调用OC系统类
    [self jsCallOCSystemClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
