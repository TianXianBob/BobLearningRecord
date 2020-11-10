//
//  NSObject+Model.h
//  BobJsonToModel
//
//  Created by bob on 2017/9/15.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BobModel)
/** 数据转模型的方法
 *  @param json 传入的json值
 *
 *  @return 对应的模型对象
 *
 */
+ (instancetype)bob_ModelWithJson:(NSDictionary *)json;
@end
