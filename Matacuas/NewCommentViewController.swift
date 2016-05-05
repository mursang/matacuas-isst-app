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
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("latitude: \(latitude) + longitude: \(longitude)")
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
        
        //comprobamos que la matricula es valida
        let matriculaText = matriculaTextField.text
        if ((matriculaText?.rangeOfString("-")) != nil){
            var matriculaValida = true
            
            //separamos la matricula en dos strings
            var myArray = matriculaText?.componentsSeparatedByString("-")
            let numeros = myArray![0] as String
            let letras = myArray![1] as String
            
            if (numeros.characters.count != 4){
                matriculaValida = false
            }
            //miramos que numeros sean numeros y no letras
            if (Int(numeros) == nil){
                matriculaValida = false
            }
            if (letras.characters.count != 3){
                matriculaValida = false
            }
            
            if (!matriculaValida){
                let alert = UIAlertView()
                alert.title = "ERROR"
                alert.message = "La matrícula no parece válida"
                alert.addButtonWithTitle("OK")
                alert.show()
                return;
            }
            
        }else{
            let alert = UIAlertView()
            alert.title = "ERROR"
            alert.message = "La matrícula no parece válida"
            alert.addButtonWithTitle("OK")
            alert.show()
            return;
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
        
        myHelper.sendNewComment("\(longitude)", longitude: "\(latitude)", matricula: matriculaTextField.text!, comentario: textView.text)
        

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
    @IBAction func addPhoto(sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Adjuntar foto", message: "Seleccionar modo", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { action -> Void in}
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Cámara", style: .Default) { action -> Void in
           self.imageView.image = UIImage(named: "fotoParking.jpg")
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Librería", style: .Default) { action -> Void in
            self.imageView.image = UIImage(named: "fotoParking.jpg")
        }
        actionSheetController.addAction(choosePictureAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
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
