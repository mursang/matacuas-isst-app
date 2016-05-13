//
//  MainViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit
import MapKit
import AZDropdownMenu


class MainViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var myLatitude:CLLocationDegrees = 0.0
    var myLongitude: CLLocationDegrees = 0.0;

    var menu = AZDropdownMenu(titles:[])
    
    
    let myHelper:ConnectionHelper = ConnectionHelper.sharedInstance
    var jsonResponseDic:NSDictionary = NSDictionary()
    
    var zoomed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (prefs.boolForKey("moderador")){
           menu = AZDropdownMenu(titles: ["","Mis Comentarios","Comentarios recibidos","Moderar","Cerrar sesión"])
        }else{
           menu = AZDropdownMenu(titles: ["","Mis Comentarios","Comentarios recibidos","Cerrar sesión"])
        }
        
        
        mapView.delegate = self;
        
      
        //localizamos al usuario nada mas entrar al mapa.
        locateUser();
        
        
        menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
            if (indexPath.row == 1){
                //Mis comentarios
                self?.performSegueWithIdentifier("misComentarios", sender: nil)
            }else if(indexPath.row==2){
                 self?.performSegueWithIdentifier("comentariosRecibidos", sender: nil)
            }else if(indexPath.row == 3){
                if (prefs.boolForKey("moderador")){ //moderar
                    self?.performSegueWithIdentifier("moderarSegue", sender: nil)
                    
                }else{ //logout
                    GIDSignIn.sharedInstance().signOut()
                    self?.performSegueWithIdentifier("logOut", sender: nil)
                }
            }else if(indexPath.row == 4 && prefs.boolForKey("moderador")){
                //logout
                GIDSignIn.sharedInstance().signOut()
                self?.performSegueWithIdentifier("logOut", sender: nil)
            }
        }
        menu.itemHeight = 64;
    
        //llamamos a coger los comentarios.
        myHelper.getAllComments()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MainViewController.reloadData(_:)),
            name: "loadedAllComments",
            object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        myHelper.getAllComments()
    }
    
    
    
    func reloadData(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let messageString:String = userInfo["jsonString"]!
        let myDic = convertStringToDictionary(messageString)
        jsonResponseDic = myDic!
        
        print(jsonResponseDic)
        //MAP
        loadPinsOnMap(jsonResponseDic)
        
    }
    
    func loadPinsOnMap(dic:NSDictionary){
        
        
        for object in dic as NSDictionary{
            let myInfoDic:NSDictionary = object.value as! NSDictionary
            
            let location = CLLocationCoordinate2DMake((myInfoDic["latitud"]?.doubleValue)!, (myInfoDic["longitud"]?.doubleValue)!)
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = myInfoDic["descripcion"] as? String
            mapView.addAnnotation(dropPin)
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
    
    
    @IBAction func showDropdown(sender: AnyObject) {
        if (self.menu.isDescendantOfView(self.view) == true) {
            self.menu.hideMenu()
        } else {
            self.menu.showMenuFromView(self.view)
        }
    }
    
    
    
    func locateUser(){
        //localizamos
        mapView.showsUserLocation = true;
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let latitude:CLLocationDegrees = (mapView.userLocation.location?.coordinate.latitude)!;
        let longitude:CLLocationDegrees = (mapView.userLocation.location?.coordinate.longitude)!;
        //hacemos zoom
        if (!zoomed){
            let latDelta:CLLocationDegrees = 0.02
            let lonDelta:CLLocationDegrees = 0.02
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.setRegion(region, animated: true)
            zoomed = true
        }
        myLatitude = latitude
        myLongitude = longitude
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation.coordinate.latitude != mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude != mapView.userLocation.coordinate.longitude){
            let newAnnotation:MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation1")
            newAnnotation.pinColor = MKPinAnnotationColor.Green
            newAnnotation.animatesDrop = true
            newAnnotation.canShowCallout = true
            newAnnotation.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return newAnnotation
        }else{
         
            
        }
        
        return nil
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for object in jsonResponseDic as NSDictionary{
            let myInfoDic:NSDictionary = object.value as! NSDictionary
            let myDesc:String = myInfoDic["descripcion"] as! String
            let myTitle:String = (view.annotation?.title!)!
            
            print(myDesc)
            print(myTitle)
            
            if (myDesc == myTitle){
                print(myInfoDic)
                 self.performSegueWithIdentifier("detailMap", sender: myInfoDic)
                break;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "newComment"){
            
            let myVC: NewCommentViewController = segue.destinationViewController as! NewCommentViewController
            myVC.latitude = myLatitude
            myVC.longitude = myLongitude
            
        }else if(segue.identifier == "detailMap"){
            let myVC: DetailViewController = segue.destinationViewController as! DetailViewController
            myVC.jsonDic = sender as! [String : AnyObject]
        }
    }
    

}
