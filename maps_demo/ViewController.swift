//
//  ViewController.swift
//  maps_demo
//
//  Created by Admin on 20.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

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

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var mainView: UIView!
    
    var mapView: GMSMapView?
    
    @IBOutlet weak var mapViewScreen: UIView!
    
    var currentDestinationId = 0
    
    @IBAction func nextDestinationButton(_ sender: Any) {
        next()
    }
    
    @IBAction func previousDestinationButton(_ sender: Any) {
        previous()
    }
    
    @IBOutlet weak var startPointTextField: UITextField!
    
    @IBOutlet weak var finishPointTextEdit: UITextField!
    
    //MARK: search button
    @IBAction func onLaunchClicked(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
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
        
    
        //MARK: Default position of a camera
        let camera = GMSCameraPosition.camera(withLatitude: startPoint.location.latitude, longitude: startPoint.location.longitude, zoom: startPoint.zoom)
        
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: mainView.frame.width, height: mainView.frame.height)), camera: camera)
        
        mapView?.mapType = kGMSTypeHybrid
        
        mainView = mapView
        self.view.addSubview(mainView)
        self.view.addSubview(startPointTextField)
        self.view.addSubview(finishPointTextEdit)
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

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        startPointTextField.text = place.name
        finishPointTextEdit.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

