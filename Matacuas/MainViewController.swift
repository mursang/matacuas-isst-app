//
//  MainViewController.swift
//  Matacuas
//
//  Created by Angel Sans Muro on 15/4/16.
//  Copyright © 2016 Alberto Sagrado Amador. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var myLatitude:CLLocationDegrees = 0.0
    var myLongitude: CLLocationDegrees = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self;
      
        //localizamos al usuario nada mas entrar al mapa.
        locateUser();
        
        
        
        
        
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
