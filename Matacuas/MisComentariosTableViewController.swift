//
//  MisComentariosTableViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 16/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit

class MisComentariosTableViewController: UITableViewController {
    var jsonString:String = "";
    var jsonDic:Dictionary = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mis Comentarios"
        
        let myHelper:ConnectionHelper = ConnectionHelper.sharedInstance
        myHelper.getMyComments();
        
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
        
        let estado = myArray.objectForKey("aprobada") as? String
        if (estado == "0"){
            //pendiente
            cell.statusLabel.text = "Pendiente"
            cell.statusLabel.textColor = UIColor.blackColor()
        }else if(estado == "1"){
            //aprobada
            cell.statusLabel.text = "Aprobada"
            cell.statusLabel.textColor = UIColor.greenColor()
        }else{
            //rechazada
            cell.statusLabel.text = "Rechazada"
            cell.statusLabel.textColor = UIColor.redColor()
        }
        
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
