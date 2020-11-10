//
//  ViewController.m
//  RunTimeDemo
//
//  Created by bob on 2020/11/4.
//  Copyright © 2020 bob. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+BobModel.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSArray+Person.h"

/*
 1. runtime怎么添加属性、方法等
 2. runtime 如何实现 weak 属性
 3. runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）
 4. 使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？
 5. _objc_msgForward函数是做什么的？直接调用它将会发生什么？
 6. 能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
 7. 简述下Objective-C中调用方法的过程（runtime）
 8. 什么是method swizzling（俗称黑魔法）
 
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendMsg];
    [self exchangeMethod];
    [self addMethod];
    [self jsonToModel];
    [self addProperty];
}

// 发送消息
- (void)sendMsg {
    // 创建person对象
    Person *p = [Person new];
    
    // 调用对象方法
    [p eat];
    
    // 本质：让对象发送消息
    ((int8_t (*)(id, SEL))(void *) objc_msgSend)(p, @selector(eat));
}

// 方法替换
- (void)exchangeMethod {
    UIImage *image = [UIImage imageNamed:@"123"];
}

// 方法添加
- (void)addMethod {
    Person *p = [Person new];
    [p performSelector:@selector(jump)];
    [Person performSelector:@selector(jump)];
}

// 字典映射模型
- (void)jsonToModel {
    NSDictionary *json = @{@"name" : @"Bob", @"age" : @"18", @"gender" : @"女"};
    Person *p = [Person bob_ModelWithJson:json];
    NSLog(@"%@-%@-%@",p.name, p.age, p.gender);
}

- (void)addProperty {
    NSArray *a = @[];
    a.person = [Person new];
    NSLog(@"%@", a.person);
}

@end


@implementation UIImage(Runtime)
+ (void)load {
    // 方法替换
    Method imageWithName = class_getClassMethod(self, @selector(imageWithName:));
    Method imageName = class_getClassMethod(self, @selector(imageNamed:));
    method_exchangeImplementations(imageWithName, imageName);
}

+ (instancetype)imageWithName:(NSString *)name {
    // 相当于调imageName
    UIImage *img = [UIImage imageWithName:name];
    
    if (!img) {
        NSLog(@"加载图片失败");
    }
    
    return img;
}
@end
