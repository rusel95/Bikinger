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

let Map = GMS()

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet var mainView: UIView!
  
    @IBOutlet weak var mapViewScreen: UIView!
    
    @IBOutlet weak var googleView: UIView!
    
    

    @IBAction func nextDestinationButton(_ sender: Any) {
        Map.nextPoint()
    }
    
    @IBAction func previousDestinationButton(_ sender: Any) {
        Map.previousPoint()
    }
    
    
    @IBOutlet weak var startPlaceTextEdit: UITextField!
    
    @IBAction func startPlaceTextEditAction(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        startPlaceTextEdit.text = intermediatePlaces[intermediatePlaces.endIndex - 1].address
    }
    
    @IBOutlet weak var finishPlaceTextEdit: UITextField!
    
    @IBAction func finishPlaceTextEditAction(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        finishPlaceTextEdit.text = intermediatePlaces[intermediatePlaces.endIndex - 1].address
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
    }
    
    
    
    
    
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let tempPoint = Place(name: place.name, address: place.formattedAddress!, zoom: 11)
        tempPoint.location = Map.getLocation(address: tempPoint.address)
        intermediatePlaces.append(tempPoint)
        Map.setCamera(place: intermediatePlaces[intermediatePlaces.endIndex - 1])
        
        self.dismiss(animated: true, completion: nil)
        
        //тут можно будет вставить то что будет в ячейке текст едита
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

