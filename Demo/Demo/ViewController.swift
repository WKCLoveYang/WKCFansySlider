//
//  ViewController.swift
//  Demo
//
//  Created by wkcloveYang on 2020/7/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
       
        let slider = WKCFansySlider(frame: view.bounds)
        slider.bottomMagin = 200
        slider.cornerRadius = 4
        slider.progressLabelBottomMagin = 100
        view.addSubview(slider)
    }


}

