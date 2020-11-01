//
//  ProtocolViewController.swift
//  s02e06_instruments
//
//  Created by Maxim Kuznetsov on 01.11.2020.
//

import UIKit

protocol RetainCycleProtocol: NSObject {}

class ReceiverVC: UIViewController {
    var delegate: RetainCycleProtocol?
    
    deinit {
        print("ProtocolViewController deinit")
    }
}
