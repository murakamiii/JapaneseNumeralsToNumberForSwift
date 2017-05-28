//
//  ViewController.swift
//  JapaneseNumeralsToNumberForSwift
//
//  Created by MURAKAMI on 2017/05/25.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let str : String = "五"
        let convertedStr : String = str.numeralsToNumber()
        print(convertedStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

