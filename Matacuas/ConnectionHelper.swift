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
    
    let serverURL = "http://1-dot-isst-matacuas-grupo12-1279.appspot.com";
    
    
    func sendNewComment(longitude:String, latitude:String, matricula:String, comentario:String){
        let serviceURL = serverURL+"/NewInfraccion"
        let stringPost = "latitud="+latitude+"&longitud="+longitude+"&matricula="+matricula+"&descripcion="+comentario
        

        
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
    
    
    
    
    
    

}
