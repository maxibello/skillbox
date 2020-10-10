//
//  PrimeNumberVC.swift
//  s02e05_concurrency
//
//  Created by Максим on 30.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class PrimeNumberVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var executionInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func process(_ sender: Any) {
        
        guard let text = self.textField.text,
        let n = Int(text) else { return }
        executionInfo = []
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for i in 1...n {
                let primeResult = self.isPrime(i)
                
                if primeResult.value {
                    let output = String(format: "%i is prime, calculation time: %i ns", i, primeResult.calcTime)
                    self.executionInfo.append(output)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    func isPrime(_ n: Int) -> (value: Bool, calcTime: UInt64) {
        let start = DispatchTime.now().uptimeNanoseconds

        guard n >= 2     else { return (value: false, calcTime: DispatchTime.now().uptimeNanoseconds - start)  }
        guard n != 2     else { return (value: true, calcTime: DispatchTime.now().uptimeNanoseconds - start)  }
        guard n % 2 != 0 else { return (value: false, calcTime: DispatchTime.now().uptimeNanoseconds - start) }
        
        let result = !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
        return (value: result, calcTime: DispatchTime.now().uptimeNanoseconds - start)
    }
}

extension PrimeNumberVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return executionInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExecutionCell")!
        cell.textLabel?.text = executionInfo[indexPath.row]
        return cell
    }
    
    
}
