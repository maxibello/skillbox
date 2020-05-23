//
//  AdditionalViewController.swift
//  skillbox_9
//
//  Created by Максим Кузнецов on 23.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class AdditionalViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var fromLabel: UILabel?

    @IBOutlet weak var arrowLabel: UILabel?

    @IBOutlet weak var toLabel: UILabel?

    @IBOutlet weak var bottomLabel: UILabel?

    var isFromBig = false

    var isToBig = false

    

    @IBAction func showHideImage() {

        imageView?.isHidden.toggle()

    }



    @IBAction func showHideBottomLabel() {

        bottomLabel?.isHidden.toggle()

    }

    

    @IBAction func showHideArrowLabel() {

        arrowLabel?.isHidden.toggle()

    }

    

    @IBAction func showHideToLabel() {

        toLabel?.isHidden.toggle()

    }

    

    @IBAction func updateFromLabel() {

        isFromBig.toggle()

        if isFromBig {

            fromLabel?.text = "From From From From From From From From From From From From From From From From"

        } else {

            fromLabel?.text = "From"

        }

    }

    

    @IBAction func updateToLabel() {

        isToBig.toggle()

        if isToBig {

            toLabel?.text = "To To To To To To To To To To To To To To To To To To To To To To To To To To To To To To To To To"

        } else {

            toLabel?.text = "To"

        }

    }

}
