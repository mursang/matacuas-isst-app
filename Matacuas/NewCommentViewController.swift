//
//  NewCommentViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit
import CoreLocation

class NewCommentViewController: UIViewController, UIAlertViewDelegate {

    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0
    
    @IBOutlet weak var matriculaTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func sendComment(sender: UIButton) {
        var correcto:Bool = false;
        
        //comprobamos que los dos textfield estan puestos
        if (matriculaTextField.text != ""){
            correcto = true;
        }
        
        if (!textView.text.isEmpty){
            correcto = true;
        }
        
        if (!correcto){
            let alert = UIAlertView()
            alert.title = "ERROR"
            alert.message = "Alguno de los campos está vacío"
            alert.addButtonWithTitle("OK")
            alert.show()
            return;
        }
        
        let myHelper:ConnectionHelper = ConnectionHelper.sharedInstance
        
        myHelper.sendNewComment(String(format:"%f",longitude), latitude: String(format:"%f",latitude), matricula: matriculaTextField.text!, comentario: textView.text)
        

            let alert = UIAlertView()
            alert.delegate = self
            alert.tag = 1;
            alert.title = "GUARDADO"
            alert.message = "Comentario guardado correctamente."
            alert.addButtonWithTitle("OK")
            alert.show()
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
