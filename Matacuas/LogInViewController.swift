//
//  LogInViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, GIDSignInUIDelegate{
    let serverURL = "http://1-dot-isst-matacuas-grupo12-1279.appspot.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     //simulamos un login con un usuario.
     @IBAction func logInGoogle(sender: UIButton) {
        

        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(LogInViewController.loginUser(_:)),
            name: "signedIn",
            object: nil)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
     }
    
    func loginUser(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let email:String = userInfo["email"]!
        let serviceURL = serverURL+"/LoginUser"
        let stringPost = "email="+email+"&operacion=checkIfUserExists"
        
        print(serviceURL + stringPost)
        
        let request = NSMutableURLRequest(URL: NSURL(string: serviceURL)!)
        request.HTTPMethod = "POST"
        let postString = stringPost
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: NSISOLatin1StringEncoding)
            print("responseString = \(responseString)")
            self.handleResponse(responseString!)
            
        }
        task.resume()

    }
    
    
    
    func handleResponse(jsonString:NSString){
        let myDic = convertStringToDictionary(jsonString as String)
        print(myDic)
        //si el status es true, ok
        if (myDic!["status"] as! Bool){
            print(myDic!["userId"] as! String)
            //guardamos en las settings de la app el userId para poder comunicarnos con el servidor
            let userId = myDic!["userId"];
            let moderador:Bool = myDic!["moderador"] as! Bool;
            
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setBool(moderador, forKey: "moderador")
            prefs.setValue(userId, forKeyPath: "userId")
            prefs.synchronize()
            
            //segue
           self.performSegueWithIdentifier("mainSegue", sender: nil);
        }else{
            //hay que registrar
            //si el status no es true, debemos pedirle que se registre con la matrícula.
            print("no existe en la bbdd")
            
        }
        
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
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
