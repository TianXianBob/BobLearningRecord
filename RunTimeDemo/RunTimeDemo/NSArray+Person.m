//
//  NSArray+Person.m
//  RunTimeDemo
//
//  Created by bob on 2020/11/8.
//  Copyright © 2020 bob. All rights reserved.
//

#import "NSArray+Person.h"
#import <objc/runtime.h>

@implementation NSArray (Person)

- (void)setPerson:(Person *)person {
    objc_setAssociatedObject(self, @selector(person), person, OBJC_ASSOCIATION_RETAIN);
}


- (Person *)person {
    return objc_getAssociatedObject(self, _cmd);
}
@end
