//
        
        
/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** ViewController.swift
 ** Metal_01

 *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Description *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** Author : Vision HIK
 ** Created: 2022/2/12
 ** Revised: Vision HIK
 ** Copyright © 2022 Hangzhou Hikvision Digital Technology Co. LTD. All rights reserved.

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/


    

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var device: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let dev = MTLCreateSystemDefaultDevice() else {
            fatalError("your GPU does not support Metal!")
        }
        device.text = "Your system has the following GPU(s):\n" + "\(dev.name)\n"
    }


}

