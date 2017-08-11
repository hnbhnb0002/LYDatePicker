//
//  ViewController.swift
//  SmartDatePicker
//
//  Created by 罗源 on 2017/6/12.
//  Copyright © 2017年 罗源. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var datePicker : SmartDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = SmartDatePicker(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
        
        self.view.addSubview(datePicker)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showDate(_ sender: Any) {
        let alert = UIAlertController(title: "\(datePicker.seletedDate!)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

