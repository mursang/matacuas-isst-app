//
//  ComentariosRecibidosTableViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 5/5/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class ComentariosRecibidosTableViewController: UITableViewController {

    var jsonString:String = "";
    var jsonDic:Dictionary = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor:UIColor = UIColor(red:230.0/255.0,green:230.0/255.0,blue:230.0/255.0,alpha:1)
        
        self.tableView.backgroundColor = myColor
        
        self.title = "Comentarios recibidos"
        
        let myHelper:ConnectionHelper = ConnectionHelper.sharedInstance
        myHelper.getReceivedComments();
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MisComentariosTableViewController.reloadTable(_:)),
            name: "loadedComments",
            object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func reloadTable(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let messageString:String = userInfo["jsonString"]!
        jsonString = messageString
        let myDic = convertStringToDictionary(jsonString)
        jsonDic = myDic!
        self.tableView.reloadData()
        
    }
    
    func shareButton(sender:AnyObject){
        
        let buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let myArray = Array(jsonDic.values)[indexPath!.row]
            let shareHelper:ShareHelper = ShareHelper.sharedInstance
            let matricula:String = myArray.objectForKey("matricula") as! String
            let comentario:String = (myArray.objectForKey("descripcion") as? String)!
            let textoCompartir:String = "\(matricula): \(comentario). Vía @MatacuasApp"
            let latitud:String = myArray.objectForKey("latitud") as! String
            let longitud:String = myArray.objectForKey("longitud") as! String
            
            let localizacion:String = "https://www.google.com/maps/search/\(latitud),\(longitud)"
            
            //ya tenemos la celda. Ahora abrimos el menu de Share
            let actionSheetController: UIAlertController = UIAlertController(title: "Compartir en...", message: "", preferredStyle: .ActionSheet)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { action -> Void in}
            actionSheetController.addAction(cancelAction)
            let twitterAction: UIAlertAction = UIAlertAction(title: "Twitter", style: .Default) { action -> Void in
                shareHelper.shareOnTwitter(self, text:textoCompartir)
            }
            actionSheetController.addAction(twitterAction)
            let facebookAction: UIAlertAction = UIAlertAction(title: "Facebook", style: .Default) { action -> Void in
                shareHelper.shareOnFacebook(self, text:textoCompartir)
                
            }
            actionSheetController.addAction(facebookAction)
            let otherAction: UIAlertAction = UIAlertAction(title: "Otros", style: .Default) { action -> Void in
                shareHelper.shareOthers(self, text: textoCompartir,location:localizacion)
            }
            actionSheetController.addAction(otherAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return jsonDic.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comentCell", forIndexPath: indexPath) as! ComentarioTableViewCell
        
        let myArray = Array(jsonDic.values)[indexPath.row]
        
        cell.fechaLabel.text = myArray.objectForKey("fecha") as? String
        cell.matriculaLabel.text = "Matrícula: "+(myArray.objectForKey("matricula") as! String)
        cell.comentarioLabel.text = myArray.objectForKey("descripcion") as? String
        
        cell.shareButton.addTarget(self, action: #selector(MisComentariosTableViewController.shareButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc:DetailViewController = segue.destinationViewController as! DetailViewController
        vc.jsonDic = jsonDic
        
    }
    
    
}
