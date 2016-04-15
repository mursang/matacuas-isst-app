//
//  LogInViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     //simulamos un login con un usuario.
     @IBAction func logInGoogle(sender: UIButton) {
        
        //guardamos en las settings de la app el userId para poder comunicarnos con el servidor
        
        //este userId está guardado en la bbdd de Google App Engine ya.
        let userId = "5760820306771968";
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        prefs.setValue(userId, forKeyPath: "userId");
        prefs.synchronize();
        
        //ejecutamos el login
        self.performSegueWithIdentifier("mainSegue", sender: nil);
        
     }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
