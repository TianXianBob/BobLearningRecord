//
//  NSObject+Model.m
//  BobJsonToModel
//
//  Created by bob on 2017/9/15.
//  Copyright © 2017年 bob. All rights reserved.
//

/** runTime方式 字典转模型*/
#import "NSObject+BobModel.h"
#import <objc/runtime.h>

@implementation NSObject (BobModel)

+ (instancetype)bob_ModelWithJson:(NSDictionary *)json{
    id objc = [[self alloc]init];
    
    unsigned int count = 0;

    /** 获得一个指向该类成员变量的指针
     *  class_copyIvarList(class,count)
     *  class 表示类的信息
     *  count 表示成员变量的个数
     *  Ivar表示成员变量指针的list
     */
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i =0; i < count; i ++) {
        // 获得指向某个成员变量的指针
        Ivar ivar = ivars[i];
        // 根据ivar获得其成员变量的名称--->C语言的字符串
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d----%@",i,key);
        
        // 去掉对象前的'_'
        key = [key substringFromIndex:1];
        // 根据成员属性名去字典中查找对应的value
        id value = json[key];
        
        // 解析value为字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 首先要取到该模型的名字，就是该属性的类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
           
            // 生成的是这种@"@\"User\"" 类型，现在转为 @"User"
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex: range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            
            // 根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            
            if (modelClass) { // 有对应的模型才需要转
                // 把字典转模型
                value  =  [modelClass bob_ModelWithJson:value];
            }
            
        }
        
        
        // 查询array中是否有需要转换的json
        if ([value isKindOfClass:[NSArray class]]) {
            // 判断对应类有没有实现字典数组转模型数组的协议
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                // 获取数组中字典对应的模型
                NSString *type =  [idSelf arrayContainModelClass][key];
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model =  [classModel bob_ModelWithJson:dict];
                    [arrM addObject:model];
                }
                
                // 把模型数组赋值给value
                value = arrM;
                
            }
        }
        
        if(value){
            [objc setValue:value forKey:key];
        }
        
    }
    free(ivars);
    
    
    
    return objc;
}

+ (id)arrayContainModelClass {
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *key = [NSString stringWithFormat:@"%s", property_getName(property)];
        NSString *value = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
        
        // 裁剪
//        NSRange range = [value rangeOfString:@"\""];
//        value = [value substringFromIndex:range.location + range.length];
//        range = [value rangeOfString:@"\""];
//        value = [value substringToIndex:range.location];
        
        [dictM setValue:value forKey:key];
        
    }
    free(properties);
    return dictM;
}

@end
