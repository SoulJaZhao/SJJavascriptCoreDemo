//
//  Person.h
//  SJJavascriptCoreDemo
//
//  Created by SDPMobile on 2017/9/6.
//  Copyright © 2017年 SoulJa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol PersonJSExport <JSExport>
@property (nonatomic, strong) NSString *name;

- (void)play;

// 调用多个参数的方法，JS函数命名规则和OC还不一样，很可能调用不到对应的JS生成的函数，为了保证生成的JS函数和OC方法名一致，OC提供了一个宏JSExportAs，用来告诉JS应该生成什么样的函数对应OC的方法，这样就不会调错了。

// PropertyName:JS函数生成的名字
// Selector:OC方法名
// JS就会自动生成playGame这个方法
JSExportAs(playGame, - (void)playWithGame:(NSString *)game time:(NSString *)time);
@end

@interface Person : NSObject <PersonJSExport>

@property (nonatomic, strong) NSString *name;

- (void)playWithGame:(NSString *)game time:(NSString *)time;

@end
