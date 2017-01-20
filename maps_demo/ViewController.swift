//
//  ViewController.swift
//  maps_demo
//
//  Created by Admin on 20.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps

class Point {
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
    
    //MARK: An array of Points
    let startPoint = Point(name: "init.dp.ua", location: CLLocationCoordinate2DMake(48.465401, 35.028503), zoom: 12)
    let intermediatePoints = [Point(name: "init.dp.ua", location: CLLocationCoordinate2DMake(48.460174, 35.043961), zoom: 17),
                        Point(name: "Мост-Сити", location: CLLocationCoordinate2DMake(48.467262, 35.051122), zoom: 16),
                        Point(name: "ДИИТ", location: CLLocationCoordinate2DMake(48.435387, 35.046489), zoom: 16)]
    
    //MARK: When view was just load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //So this is my kinda identifier of ios app in GoogleMaps
        GMSServices.provideAPIKey("AIzaSyB_EZxn5ma7uGtxLPPnfkIbKIpazFxKKNQ")
    
        //MARK: Default position of a camera
        let camera = GMSCameraPosition.camera(withLatitude: startPoint.location.latitude, longitude: startPoint.location.longitude, zoom: startPoint.zoom)
        
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100)), camera: camera)
        
        mapView?.mapType = kGMSTypeHybrid
        
        self.view = mapView
}
    
    

    //MARK: next/previos buttons functions
    func next() {
        if currentDestinationId < intermediatePoints.count - 1
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
    
    //MARK: I can set my camera in needed position using this function
    private func setCamera(id: Int) {
        CATransaction.begin()
        CATransaction.setValue(6, forKey: kCATransactionAnimationDuration)
        
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: intermediatePoints[id].location, zoom: intermediatePoints[id].zoom))
        
        CATransaction.commit()
        
        let marker = GMSMarker(position: intermediatePoints[id].location)
        marker.title = intermediatePoints[id].name
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
    }

}

