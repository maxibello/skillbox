//
//  SegmentedViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 19.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var purpleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAll()
        greenView.isHidden = false
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        hideAll()
        switch sender.selectedSegmentIndex {
        case 0:
            greenView.isHidden = false
        case 1:
            blueView.isHidden = false
        case 2:
            purpleView.isHidden = false
        default:
            print("Unsupported index: \(sender.selectedSegmentIndex)")
        }
    }
    
    private func hideAll() {
        greenView.isHidden = true
        blueView.isHidden = true
        purpleView.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
