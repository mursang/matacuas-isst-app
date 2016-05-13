//
//  DetailViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 8/5/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var jsonDic:Dictionary = [String: AnyObject]()
    var comentarioId:String = ""
    
    @IBOutlet weak var matriculaTextfield: UITextField!
    @IBOutlet weak var descripcionTextfield: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalle Comentario"

        
        let denunciarButton : UIBarButtonItem = UIBarButtonItem(title: "Denunciar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailViewController.denunciar))

        self.navigationItem.rightBarButtonItem = denunciarButton
        
        
        
        matriculaTextfield.text = jsonDic["matricula"] as? String
        descripcionTextfield.text = jsonDic["descripcion"] as? String
        comentarioId = jsonDic["id"] as! String
        print("RECIBIDO")
        print(jsonDic)
    }
    
    func denunciar(){
        let myHelper:ConnectionHelper = ConnectionHelper.sharedInstance
        myHelper.denunciarComentario(comentarioId)
        
        let alert = UIAlertView()
        alert.delegate = self
        alert.tag = 1;
        alert.title = "DENUNCIADO"
        alert.message = "Comentario denunciado correctamente. Los administradores tomarán medidas."
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
