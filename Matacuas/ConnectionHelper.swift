//
//  ConnectionHelper.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class ConnectionHelper: NSObject {
    static let sharedInstance = ConnectionHelper()
    
    let serverURL = "http://1-dot-isst-matacuas-grupo12-1279.appspot.com"
    
    
    func sendNewComment(latitude:String, longitude:String, matricula:String, comentario:String){
        let myUserId:String = NSUserDefaults.standardUserDefaults().objectForKey("userId") as! String;
        
        let serviceURL = serverURL+"/NewInfraccion"
        var stringPost = "latitud="+latitude+"&longitud="+longitude+"&matricula="+matricula
        stringPost += "&descripcion="+comentario+"&userId="+myUserId

        print("ENVIO: "+stringPost)
        //generamos la peticion post
        let request = NSMutableURLRequest(URL: NSURL(string: serviceURL)!)
        request.HTTPMethod = "POST"
        let postString = stringPost
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }

            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    
    func getMyComments() -> String{
        let myUserId:String = NSUserDefaults.standardUserDefaults().objectForKey("userId") as! String;
        let serviceURL = serverURL+"/GetMyComments"
        let stringPost = "userId="+myUserId
        
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
            NSNotificationCenter.defaultCenter().postNotificationName("loadedComments", object: nil, userInfo: ["jsonString":responseString!])
            
            
        }
        task.resume()
        
        return ""
    }
    
    func getAllComments() -> String{
        let request = NSMutableURLRequest(URL: NSURL(string: serverURL+"/GetAllComments")!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                } else {
                    let responseString = NSString(data: data!, encoding: NSISOLatin1StringEncoding)
                    NSNotificationCenter.defaultCenter().postNotificationName("loadedAllComments", object: nil, userInfo: ["jsonString":responseString!])
                }
        })
        
        task.resume()
        return ""
    }
    
    
    
    
    
    
    
    

}
