//
//  ShareHelper.swift
//  Matacuas
//
//  Created by Alberto Sagrado Amador on 11/5/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit
import Social
class ShareHelper: NSObject {
    static let sharedInstance = ShareHelper()

    func shareOnTwitter(controller:UIViewController, text:String){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(text)
            controller.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOnFacebook(controller:UIViewController,text:String){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(text)
            controller.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOthers(controller:UIViewController,text:String,location:String){
        let textFinal:String = "\(text). Ha ocurrido en: \(location)"
        let activityViewController = UIActivityViewController(activityItems: [textFinal as NSString], applicationActivities: nil)
        controller.presentViewController(activityViewController, animated: true, completion: {})
    }

}
