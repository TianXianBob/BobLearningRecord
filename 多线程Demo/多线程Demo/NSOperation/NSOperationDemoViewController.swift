//
//  NSOperationDemoViewController.swift
//  多线程Demo
//
//  Created by bob on 2020/10/22.
//  Copyright © 2020 bob. All rights reserved.
//

import UIKit

// 使用流程
//1.创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。
//2.创建队列：创建 NSOperationQueue 对象。
//3.将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中。
class NSOperationDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        createBlockOperation()
//        createOperationQueue()
//        createDependency()
        initTicket()
    }
    
    func createBlockOperation() {
        print("createBlockOperation start")
        // 不用OperationQueue, 默认再主线程执行
        let op = BlockOperation {
            for i in 0..<3 {
                sleep(2)
                print("op1 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op2 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op3 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op4 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op5 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op6 -- \(i) --- \(Thread.current)")
            }
        }
        
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op7 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.addExecutionBlock {
            for i in 0..<3 {
                sleep(2)
                print("op8 -- \(i) --- \(Thread.current)")
            }
        }
        
        op.start()
        print("createBlockOperation end")
    }
    
    
    func createOperationQueue() {
        print("createOperationQueue start")

        // 创建队列
        let queue = OperationQueue()
        
        // 创建操作
        let op1 = BlockOperation {
            for i in 0..<3 {
                sleep(2)
                print("op1 -- \(i) --- \(Thread.current)")
            }
        }
        
        queue.addOperation(op1)
        queue.addOperation {
            for i in 0..<3 {
                sleep(2)
                print("op2 -- \(i) --- \(Thread.current)")
            }
        }
        print("createBlockOperation end")
    }
    
    func createDependency() {
        print("createDependency start")

        // 创建队列
        let queue = OperationQueue()
        let op1 = BlockOperation {
            for i in 0..<3 {
                sleep(2)
                print("op1 -- \(i) --- \(Thread.current)")
            }
        }
        
        let op2 = BlockOperation {
            for i in 0..<3 {
                sleep(2)
                print("op2 -- \(i) --- \(Thread.current)")
            }
        }
        
        op2.addDependency(op1)
        queue.addOperation(op1)
        queue.addOperation(op2)
        print("createDependency end")

    }
    
    var ticketNumber = 0
    let lock = NSLock()
    func initTicket() {
        ticketNumber = 50
        
        let q1 = OperationQueue()
        q1.name = "上海火车站"
        q1.maxConcurrentOperationCount = 1
        
        let q2 = OperationQueue()
        q1.name = "杭州火车站"
        q2.maxConcurrentOperationCount = 1
        
        let op1 = BlockOperation {
            self.saleSafety()
        }
        
        let op2 = BlockOperation {
            self.saleSafety()
        }
        
        q1.addOperation(op1)
        q2.addOperation(op2)
    }
    
    func saleSafety() {
        while true {
            lock.lock()
            
            if ticketNumber > 0 {
                ticketNumber -= 1
                print("ticketNumber 剩余 \(ticketNumber) 张，当前窗口\(Thread.current)")
            }
            
            lock.unlock()
            
            if ticketNumber == 0 {
                print("票已售罄")
                break
            }
        }
    }
}
