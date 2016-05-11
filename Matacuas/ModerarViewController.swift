//
//  ModerarViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 10/5/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit
import MBProgressHUD

class ModerarViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var matriculaLabel: UILabel!
    @IBOutlet weak var rechazarButton: UIButton!
    @IBOutlet weak var descripcionTextView: UITextView!
    @IBOutlet weak var aprobarButton: UIButton!
    
    let helper:ConnectionHelper = ConnectionHelper.sharedInstance
    
    var globalDic:Dictionary = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoading()
        rechazarButton.enabled = false
        aprobarButton.enabled = false
        self.title = "Moderar"
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ModerarViewController.writeComment(_:)),
            name: "loadedComentario",
            object: nil)
        
        
        backgroundView.layer.cornerRadius = 12.0
        matriculaLabel.text = ""
        descripcionTextView.text = ""
        descripcionTextView.textAlignment = .Center
        //retrasamos la carga de la view 1 segundo
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(ModerarViewController.cargaViewDelay), userInfo: nil, repeats: false)
    }
    
    func cargaViewDelay(){
        helper.getComentarioParaModerar()
    }
    
    func writeComment(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let messageString:String = userInfo["jsonString"]!
        let myDic = convertStringToDictionary(messageString)
        let jsonDic:Dictionary = myDic!
        print(jsonDic)
        dispatch_async(dispatch_get_main_queue(),{
            let status:Bool = jsonDic["status"] as! Bool
            
            if (status){
                //ok!
                self.globalDic = jsonDic
                self.rechazarButton.enabled = true
                self.aprobarButton.enabled = true
                
                self.matriculaLabel.text = jsonDic["matricula"] as? String
                let texto = String(format: "\n %@", (jsonDic["descripcion"] as? String)!)
                self.descripcionTextView.text = texto
            }else{
                let alert = UIAlertView()
                alert.delegate = self
                alert.tag = 1;
                alert.title = ""
                alert.message = "¡Vaya! Parece que no hay más comentarios para moderar. Vuelve más tarde."
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            self.stopLoading()
        })
    }
    
    
    func startLoading(){
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Cargando..."
    }
    
    func stopLoading(){
        dispatch_async(dispatch_get_main_queue(),{
             MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func resetText(){
        descripcionTextView.text = ""
        matriculaLabel.text = ""
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rechazarComentario(sender: AnyObject) {
        helper.rechazarComentario((globalDic["id"] as? String)!)
        rechazarButton.enabled = false
        aprobarButton.enabled = false
        resetText()
        startLoading()
    }
    @IBAction func aprobarComentario(sender: AnyObject) {
        helper.aprobarComentario((globalDic["id"] as? String)!)
        rechazarButton.enabled = false
        aprobarButton.enabled = false
        resetText()
        startLoading()
    }
}
