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



class ViewController: UIViewController, UISearchBarDelegate {
    
    
    
    @IBOutlet var mainView: UIView!
    
    var mapView: GMSMapView?
    
    @IBOutlet weak var mapViewScreen: UIView!
    
    @IBOutlet weak var googleView: UIView!
    
    var currentPlaceId = 0
    //var myCamera = GoogleCamera()

    @IBAction func nextDestinationButton(_ sender: Any) {
        next()
    }
    
    @IBAction func previousDestinationButton(_ sender: Any) {
        previous()
    }
    
    
    @IBOutlet weak var startPlaceTextEdit: UITextField!
    
    @IBOutlet weak var finishPlaceTextEdit: UITextField!
    
    //MARK: search button
    @IBAction func onLaunchClicked(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    //MARK: When view was just load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //MARK: Default position of a camera
        let camera = GMSCameraPosition.camera(withLatitude: defaultPlace.location.latitude, longitude: defaultPlace.location.longitude, zoom: defaultPlace.zoom)
        
        mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: googleView.frame.width, height: googleView.frame.height)), camera: camera)
        
        mapView?.mapType = kGMSTypeHybrid
        
        googleView = mapView
        
        self.view.addSubview(googleView)
        //mainView = googleView
        
        //self.view.addSubview(mainView)
        //self.view.addSubview(startPlaceTextEdit)
        //self.view.addSubview(finishPlaceTextEdit)
    }
    
    
    
    
    //MARK: next/previos buttons functions
    func next() {
        if currentPlaceId < intermediatePlaces.count - 1
        {
            currentPlaceId += 1
            //setCamera(id: currentPlaceId)
            intermediatePlaces[currentPlaceId].setCamera(mapView: mapView!)
        }
    }
    
    func previous() {
        if currentPlaceId > 0 {
            currentPlaceId -= 1
            intermediatePlaces[currentPlaceId].setCamera(mapView: mapView!)
        }
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        /*print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")*/
        
        let tempPoint = Place(name: place.name, address: place.formattedAddress!, zoom: 11)
        //print(tempPoint.address, tempPoint.location)
        
        intermediatePlaces.append(tempPoint)
        intermediatePlaces[intermediatePlaces.endIndex - 1].setCamera(mapView: mapView!)
        //print(intermediatePlaces[intermediatePlaces.endIndex - 1].address, intermediatePlaces[intermediatePlaces.endIndex - 1].location)
        
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

