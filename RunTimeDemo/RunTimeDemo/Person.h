//
//  Person.h
//  RunTimeDemo
//
//  Created by bob on 2020/11/4.
//  Copyright © 2020 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *gender;


- (void)eat;
@end

NS_ASSUME_NONNULL_END
