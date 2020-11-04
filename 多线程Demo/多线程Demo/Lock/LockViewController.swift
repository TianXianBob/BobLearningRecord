//
//  LockViewController.swift
//  多线程Demo
//
//  Created by bob on 2020/10/26.
//  Copyright © 2020 bob. All rights reserved.
//

import UIKit

class LockViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        createSynchronized()
        //        createDispatchSemaphore()
        //        createNSLock()
        //        createNSRecursiveLock()
        //        createNSConditionLock()
        //        createPthread_mutex()
        
    }
    
    
    
    
    // synchronized
    // http://yulingtianxia.com/blog/2015/11/01/More-than-you-want-to-know-about-synchronized/
    // https://swifter.tips/lock/
    func createSynchronized() {
        var arr1: [String] = []
        DispatchQueue.global().async {
            self.synchronized(lock: arr1 as AnyObject) {
                arr1.append("1")
                print("1 \(arr1)")
                
                sleep(2)
                arr1.append("4")
                print("4 \(arr1)")
            }
        }
        
        DispatchQueue.global().async {
            self.synchronized(lock: arr1 as AnyObject) {
                arr1.append("2")
                print("2 \(arr1)")
            }
        }
        
        DispatchQueue.global().async {
            self.synchronized(lock: arr1 as AnyObject) {
                arr1.append("3")
                print("3 \(arr1)")
            }
        }
    }
    
    func synchronized(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    // dispatch_semaphore
    func createDispatchSemaphore() {
        let semaphore = DispatchSemaphore.init(value: 0)
        var i = 10
        DispatchQueue.global().async {
            i = 100
            print("i1 = \(i)")
            sleep(4)
            
            i = 1000
            print("i2 = \(i)")
            semaphore.signal()
        }
        
        DispatchQueue.global().async {
            sleep(1)
            let _ = semaphore.wait(timeout: .now() + 2)
            print("i3 = \(i)")
        }
        
    }
    
    
    // NSLock
    func createNSLock() {
        var arr1: [String] = []
        let lock = NSLock()
        DispatchQueue.global().async {
            lock.lock()// try()不会阻塞线程
            arr1.append("1")
            print("1 \(arr1)")
            
            sleep(2)
            arr1.append("4")
            print("4 \(arr1)")
            lock.unlock()
            
        }
        
        DispatchQueue.global().async {
            lock.lock()
            arr1.append("2")
            print("2 \(arr1)")
            lock.unlock()
        }
    }
    
    // 递归锁
    var block: ((Int) -> (Void))?
    func createNSRecursiveLock() {
        //        let lock = NSLock()// NSLock递归上锁会死锁
        let lock = NSRecursiveLock()
        DispatchQueue.global().async {
            self.block = { i in
                lock.lock()
                
                if let b = self.block {
                    if (i > 0) {
                        print(i)
                        sleep(1)
                        b(i-1)
                    }
                }
                
                
                lock.unlock()
            }
            
            if let b = self.block {
                b(5)
            }
            
        }
    }
    
    /*
     当我们在使用多线程的时候，有时一把只会lock和unlock的锁未必就能完全满足我们的使用。因为普通的锁只能关心锁与不锁，而不在乎用什么钥匙才能开锁，而我们在处理资源共享的时候，多数情况是只有满足一定条件的情况下才能打开这把锁.
     */
    func createNSConditionLock() {
        let lock = NSConditionLock()
        var arr: [String] = []
        let kHasData = 1
        let kNoData = 0
        
        DispatchQueue.global().async {
            while true {
                lock.lock(whenCondition: kNoData)
                arr.append("1")
                print("arr.count = \(arr.count)")
                lock.unlock(withCondition: kHasData)
                sleep(1)
            }
        }
         
        DispatchQueue.global().async {
            while true {
                lock.lock(whenCondition: kHasData)
                arr.removeLast()
                print("arr.count = \(arr.count)")
                lock.unlock(withCondition: kNoData)
                sleep(1)
            }
        }
    }
    
    
    func createPthread_mutex() {
        var pthread_mutex = pthread_mutex_t()
        pthread_mutex_init(&pthread_mutex, nil)
        DispatchQueue.global().async {
            pthread_mutex_lock(&pthread_mutex)
            print("操作1 开始")
            sleep(3)
            print("操作1 结束")
            pthread_mutex_unlock(&pthread_mutex)
        }
        
        DispatchQueue.global().async {
            sleep(1)
            pthread_mutex_lock(&pthread_mutex)
            print("操作2")
            pthread_mutex_unlock(&pthread_mutex)
        }
    }
  
}


