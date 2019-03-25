//
//  ViewController.swift
//  OneSidedBorder
//
//  Created by ryohey on 03/25/2019.
//  Copyright (c) 2019 ryohey. All rights reserved.
//

import UIKit
import OneSidedBorder

class ViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.topBorderColor = UIColor.red
        contentView.topBorderWidth = 3
        contentView.rightBorderColor = UIColor.blue
        contentView.rightBorderMargin = 15
        contentView.rightBorderWidth = 1
        contentView.bottomBorderColor = UIColor.gray
        contentView.bottomBorderWidth = 10
        contentView.leftBorderColor = UIColor.green
        contentView.leftBorderWidth = 2
    }
}
