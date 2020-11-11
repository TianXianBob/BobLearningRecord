//
//  ViewController.m
//  KVODemo
//
//  Created by bob on 2020/11/10.
//  Copyright © 2020 bob. All rights reserved.
//

#import "ViewController.h"
#import "KVOObject.h"
#import "NSObject+KVO.h"

@interface ViewController ()
@property (nonatomic, strong) KVOObject *object1;
@property (nonatomic, strong) KVOObject *object2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.object1 = [[KVOObject alloc] init];
    self.object2 = [[KVOObject alloc] init];
    [self.object1 description];
    [self.object2 description];

//    [self.object1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self.object1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    NSLog(@"---------------");
    [self.object1 description];
    [self.object2 description];

    self.object1.name = @"lxz";
    self.object1.age = 20;
    
    [self.object1 bob_addObserver:self keyPath:@"name" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"old %@, new %@", oldValue, newValue);
    }];
    
    self.object1.name = @"GG";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"name"]) {
        
    } else {
        
    }
}


@end
