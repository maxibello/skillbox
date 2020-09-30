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
    @IBAction func process(_ sender: Any) {
        
        guard let text = self.textField.text,
        let n = Int(text) else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            for i in 1...n {
                guard let self = self else { return }
                
                let primeResult = self.isPrime(i)
                
                if self.isPrime(i).value {
                    let output = String(format: "%i is prime, calculation time: %.6f ms", i, primeResult.calcTime * 1000)
                    print(output)
                }
            }
        }
        
    }
    
    func isPrime(_ n: Int) -> (value: Bool, calcTime: CFAbsoluteTime) {
        let start = CFAbsoluteTimeGetCurrent()

        guard n >= 2     else { return (value: false, calcTime: CFAbsoluteTimeGetCurrent() - start)  }
        guard n != 2     else { return (value: true, calcTime: CFAbsoluteTimeGetCurrent() - start)  }
        guard n % 2 != 0 else { return (value: false, calcTime: CFAbsoluteTimeGetCurrent() - start) }
        
        let result = !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
        return (value: result, calcTime: CFAbsoluteTimeGetCurrent() - start)
    }
}
