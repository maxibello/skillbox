//
//  SenderVC.swift
//  s02e06_instruments
//
//  Created by Maxim Kuznetsov on 01.11.2020.
//

import UIKit

class SenderVC: UIViewController, RetainCycleProtocol {
    lazy var receiverVC: ReceiverVC = {
        let vc = ReceiverVC()
        vc.delegate = self
        return vc
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.pushViewController(receiverVC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("SenderVC deinit")
    }
}
