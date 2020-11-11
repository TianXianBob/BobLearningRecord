//
//  NSObject+KVO.h
//  KVODemo
//
//  Created by bob on 2020/11/11.
//  Copyright © 2020 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BobObserverBlock)(id observer, NSString *keyPath,id oldValue, id newValue);

@interface NSObject (KVO)

- (void)bob_addObserver:(NSObject *)observer
                keyPath:(NSString *)keypath
                  block:(BobObserverBlock)block;
@end

NS_ASSUME_NONNULL_END
