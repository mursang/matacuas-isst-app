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
    @IBOutlet weak var tableView: UITableView!
    
    var myLatitude:CLLocationDegrees = 0.0
    var myLongitude: CLLocationDegrees = 0.0;
    
    let menu = AZDropdownMenu(titles: ["","Mis Comentarios"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self;
      
        //localizamos al usuario nada mas entrar al mapa.
        locateUser();
        
        
        menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
            if (indexPath.row == 1){
                //Mis comentarios
                self?.performSegueWithIdentifier("misComentarios", sender: nil)
            }
        }
        menu.itemHeight = 64;
        
        
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
        //hacemos zoom
        let latitude:CLLocationDegrees = (mapView.userLocation.location?.coordinate.latitude)!;
        let longitude:CLLocationDegrees = (mapView.userLocation.location?.coordinate.longitude)!;
        let latDelta:CLLocationDegrees = 0.02
        let lonDelta:CLLocationDegrees = 0.02
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        myLatitude = latitude
        myLongitude = longitude

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
            
        }
    }
    

}
