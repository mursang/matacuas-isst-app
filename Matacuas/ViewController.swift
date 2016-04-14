//
//  ViewController.swift
//  Matacuas
//
//  Created by Alberto Sagrado Amador on 13/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.redColor().CGColor
        border.frame = CGRect(x: 0, y: email.frame.size.height - width, width:  email.frame.size.width, height: email.frame.size.height)
        
        border.borderWidth = width
        email.layer.addSublayer(border)
        email.layer.masksToBounds = true
        */
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

