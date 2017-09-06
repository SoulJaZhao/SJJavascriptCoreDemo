//
//  ViewController.h
//  SJJavascriptCoreDemo
//
//  Created by SDPMobile on 2017/9/6.
//  Copyright © 2017年 SoulJa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol UILabelJSExport <JSExport>

@property (nonatomic, strong) NSString *text;

@end

@interface ViewController : UIViewController


@end

