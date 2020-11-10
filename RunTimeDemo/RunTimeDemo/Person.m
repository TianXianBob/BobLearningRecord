//
//  Person.m
//  RunTimeDemo
//
//  Created by bob on 2020/11/4.
//  Copyright © 2020 bob. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person
- (void)eat {
    NSLog(@"eat now");
}

void jump(id self, SEL sel) {
    NSLog(@"jump now, %@, %@", self, NSStringFromSelector(sel));
}


+ (BOOL)resolveInstanceMethod:(SEL)name
{
    NSLog(@" >> Instance resolving %@", NSStringFromSelector(name));
      
    if (name == @selector(jump)) {
        class_addMethod([self class], name, (IMP)jump, "v@:");
        return YES;
    }
      
    return [super resolveInstanceMethod:name];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(jump)) {
        // 动态添加eat方法
        
        // 第一个参数：给哪个类添加方法，注意需要用object_getClass
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(object_getClass(self), @selector(jump), (IMP)jump, "v@:");
        
    }
    
    return [super resolveInstanceMethod:sel];
}
@end
