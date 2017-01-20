//
//  ViewController.swift
//  maps_demo
//
//  Created by Admin on 20.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps

class IntermediatePoint {
    var name = String()
    var location = CLLocationCoordinate2D()
    var zoom: Float

    //var points = []
    init(name: String, location: CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}

class ViewController: UIViewController {

    var mapView: GMSMapView?
    
    var currentDestinationId = 0
    
    @IBAction func nextDestinationButton(_ sender: Any) {
        next()
    }
    
    @IBAction func previousDestinationButton(_ sender: Any) {
        previous()
    }
    
    let destinations = [IntermediatePoint(name: "init.dp.ua", location: CLLocationCoordinate2DMake(48.460174, 35.043961), zoom: 17),
                        IntermediatePoint(name: "Мост-Сити", location: CLLocationCoordinate2DMake(48.467262, 35.051122), zoom: 16),
                        IntermediatePoint(name: "ДИИТ", location: CLLocationCoordinate2DMake(48.435387, 35.046489), zoom: 16)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GMSServices.provideAPIKey("AIzaSyB_EZxn5ma7uGtxLPPnfkIbKIpazFxKKNQ")
    
        let camera = GMSCameraPosition.camera(withLatitude: destinations[currentDestinationId].location.latitude, longitude: destinations[currentDestinationId].location.longitude, zoom: destinations[currentDestinationId].zoom)
        
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100)), camera: camera)
        
        let marker = GMSMarker.init()
        marker.position = camera.target
        marker.title = "Init.dp.ua"
        marker.snippet = "the best IT-school"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        mapView?.mapType = kGMSTypeHybrid
        self.view = mapView
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Destination", style: .plain, target: self, action: "next")
    }
    
    

    func next() {
        if currentDestinationId < destinations.count - 1
        {
            currentDestinationId += 1
            setCamera(id: currentDestinationId)
        }
    }
    
    func previous() {
        if currentDestinationId > 0 {
            currentDestinationId -= 1
            setCamera(id: currentDestinationId)
        }
    }
    
    private func setCamera(id: Int) {
        CATransaction.begin()
        CATransaction.setValue(6, forKey: kCATransactionAnimationDuration)
        
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: destinations[id].location, zoom: destinations[id].zoom))
        
        CATransaction.commit()
        
        let marker = GMSMarker(position: destinations[id].location)
        marker.title = destinations[id].name
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
    }

}

