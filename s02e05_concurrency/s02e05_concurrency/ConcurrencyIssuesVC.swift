//
//  ConcurrencyIssuesVC.swift
//  s02e05_concurrency
//
//  Created by Максим on 09.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ConcurrencyIssuesVC: UIViewController {
    
    @IBAction func deadlock(_ sender: Any) {
        DispatchQueue.main.sync {}
    }
    
    @IBAction func raceCondition(_ sender: Any) {
        
        var arr: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        concurrentQueue.async {
            for i in 0...1000 {
                usleep(3)
                arr.append("🌎: \(i)")
            }
        }

        concurrentQueue.async {
            for i in 0...1000 {
                arr[i] = "⚽: \(i)"
            }
        }
    }
    
    @IBAction func priorityInversion(_ sender: Any) {
        enum Color: String {
            case blue = "🔵"
            case white = "⚪️"
        }

        func output(color: Color, times: Int) {
            for _ in 1...times {
                print(color.rawValue)
            }
        }

        let starterQueue = DispatchQueue(label: "starter", qos: .userInteractive)
        let utilityQueue = DispatchQueue(label: "utility", qos: .utility)
        let backgroundQueue = DispatchQueue(label: "background", qos: .background)
        let count = 10

        starterQueue.async {

            backgroundQueue.async {
                output(color: .white, times: count)
            }

            backgroundQueue.async {
                output(color: .white, times: count)
            }

            utilityQueue.async {
                output(color: .blue, times: count)
            }

            utilityQueue.async {
                output(color: .blue, times: count)
            }
            
            backgroundQueue.sync {}
            
        }    }

}
