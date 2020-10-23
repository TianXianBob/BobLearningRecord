//
//  GCDDemoViewController.swift
//  多线程Demo
//
//  Created by bob on 2020/10/21.
//  Copyright © 2020 bob. All rights reserved.
//

import UIKit

class GCDDemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createQueue()
        createSyncJob()
        createAsyncJob()
        createGroupNotify()
        createGroupWait()
        createBarrier()
        createSemaphore()
    }
    
    
    //MARK: 创建队列
    func createQueue() {
        // 主队列
        let _ = DispatchQueue.main
        // 全局并发队列
        let _ = DispatchQueue.global()
        
        // 创建队列
        // params
        // label: 队列的名称，方便调试
        // qos: Quality of Service(服务质量),即线程优先级，由高到低如下，默认为default
        // - userInteractive
        // - userInitiated
        // - default
        // - utility
        // - background
        //
        // attributes:
        // - concurrent：标识队列为并行队列
        // - initiallyInactive：标识运行队列中的任务需要手动触发，由队列的 activate 方法进行触发。如果未添加此标识，向队列中添加的任务会自动运行。
        // 如果不设置该值，则表示创建串行队列。如果希望创建并行队列，并且需要手动触发，则该值需要设置为 [.concurrent, .initiallyInactive]
        //
        // autoreleaseFrequency:autoreleaseFrequency 的类型为枚举（enum），用来设置负责管理任务内对象生命周期的 autorelease pool 的自动释放频率。包含三个类型：
        
        // - inherit：继承目标队列的该属性，
        // - workItem：跟随每个任务的执行周期进行自动创建和释放
        // - never：不会自动创建 autorelease pool，需要手动管理。
        //
        // target: 这个参数设置了队列的目标队列，即队列中的任务运行时实际所在的队列。目标队列最终约束了队列的优先级等属性。
        
        let _ = DispatchQueue(label: "bob.test.queue2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
    }
    
    
    // 同步任务
    func createSyncJob() {
        // 同步任务，阻塞当前线程, 下面是死锁现象
//        print("createSyncJob = a")
//        DispatchQueue.main.sync {
//            print("createSyncJob = b")
//        }
//        print("createSyncJob = c")
        
        
        // 死锁现象
//        let queue = DispatchQueue.init(label: "com.bob.SERIAL")
//        queue.async {
//            print("com.bob.SERIAL = a")
//            queue.sync {
//                print("com.bob.SERIAL = b")
//            }
//            print("com.bob.SERIAL = c")
//        }
    }
    
    // 异步任务
    func createAsyncJob() {
        // 异步任务，不阻塞当前线程
        print("createAsyncJob = a")
        DispatchQueue.main.async {
            print("createAsyncJob = b")
        }
        print("createAsyncJob = c")
    }
    
    // GroupWait
    func createGroupWait() {
        let queue = DispatchQueue.init(label: "test", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        let group = DispatchGroup()
        queue.async(group: group, qos: .default, flags: [], execute: {
            for _ in 0...5 {
                
                print("耗时任务1")
            }
        })
        queue.async(group: group, qos: .default, flags: [], execute: {
            sleep(2)
            for _ in 0...5 {
                
                print("耗时任务2")
            }
        })
        //等待上面任务执行，会阻塞当前线程，超时就执行下面的，上面的继续执行。可以无限等待 .distantFuture
        let result = group.wait(timeout: .now() + 2.0)
        switch result {
        case .success:
            print("不超时, 上面的两个任务都执行完")
        case .timedOut:
            print("超时了, 上面的任务还没执行完执行这了")
        }
        
        print("接下来的操作")
    }
    
    // Group
    // 多个异步任务执行完成后再执行后续操作
    func createGroupNotify() {
        let group = DispatchGroup()
        let globleQueue = DispatchQueue.global(qos: .default)
        
        print("notify begin")
        globleQueue.async(group: group) {
            for i in 0...5 {
                print("group01 - \(i)")
            }
        }
        
        DispatchQueue.main.async(group: group) {
            for i in 0...8 {
                print("group02 - \(i)")
            }
        }
        
        globleQueue.async(group: group) {
            for i in 0...6 {
                print("group03 - \(i)")
            }
        }
        
        group.notify(queue: .main) {
            print("ok")
        }
        
        print("after notify")
    }
    
    // 栅栏函数
    // 栅栏函数的作用用于异步任务的先后执行
    // Job1、Job2 | Barrier | Job3
    func createBarrier() {
        let queue = DispatchQueue.init(label: "com.bob.Barrier", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)

        queue.async {//任务一
            for _ in 0...3 {
                print("......")
            }
        }
        queue.async {//任务二
            for _ in 0...3 {
                print("++++++");
            }
        }
        
        queue.async(group: nil, qos: .default, flags: .barrier) {
            print("group")
        }
        
        queue.async {
            print("finish")
        }
        
        print("createBarrier finish")
    }
    
    // 用于
    func createSemaphore() {
        let semaphore = DispatchSemaphore.init(value: 0)
        var i = 10
        DispatchQueue.global().async {
            i = 100
            
            semaphore.signal()
        }
//        semaphore.wait()
        print("i = \(i)")
    }
    
}




