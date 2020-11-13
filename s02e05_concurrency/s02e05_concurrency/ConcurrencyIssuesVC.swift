//
//  ConcurrencyIssuesVC.swift
//  s02e05_concurrency
//
//  Created by Максим on 09.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class Diner {
    var isHungry = true
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
}

class ConcurrencyIssuesVC: UIViewController {
    
    @IBAction func deadlock(_ sender: Any) {
        let queue = DispatchQueue(label: "deadlock")
        queue.async {
            queue.sync {}
        }
        
    }
    
    @IBAction func raceCondition(_ sender: Any) {
        
        var arr: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        for _ in 0..<10 {
            arr.append("⚽")
        }
        
        concurrentQueue.async {
            for i in 0..<arr.count {
                arr[i] = "🌎: \(i)"
            }
        }
        
        concurrentQueue.async {
            for item in arr {
                print(item)
            }
            print("-------------------")
        }
        
        
    }
    
    @IBAction func priorityInversion(_ sender: Any) {
        
        let high = DispatchQueue.global(qos: .userInteractive)
        let medium = DispatchQueue.global(qos: .userInitiated)
        let low = DispatchQueue.global(qos: .background)

        let semaphore = DispatchSemaphore(value: 1)
        
        high.async {
            Thread.sleep(forTimeInterval: 2)
            semaphore.wait()
            defer { semaphore.signal() }

            print("High priority task is running")
        }

        for i in 1 ... 10 {
            medium.async {
                let waitTime = Double(exactly: arc4random_uniform(7))!
                print("Medium task \(i)")
                Thread.sleep(forTimeInterval: waitTime)
            }
        }

        low.async {
            semaphore.wait()
            defer { semaphore.signal() }

            print("Lowest priority task")
            Thread.sleep(forTimeInterval: 5)
        }
        
        print("_______________________")
    }
    @IBAction func liveLock(_ sender: Any) {
        
    }
    
}
