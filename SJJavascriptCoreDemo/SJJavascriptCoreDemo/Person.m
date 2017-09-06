//
//  Person.m
//  SJJavascriptCoreDemo
//
//  Created by SDPMobile on 2017/9/6.
//  Copyright © 2017年 SoulJa. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)play
{
    
    NSLog(@"%@玩",_name);
}

- (void)playWithGame:(NSString *)game time:(NSString *)time
{
    NSLog(@"%@在%@玩%@",_name,time,game);
}
@end
