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
var myPlaces = Places()

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var mainView: UIView!
  
    @IBOutlet weak var mapViewScreen: UIView!
    
    @IBOutlet weak var googleView: UIView!
    
    
    @IBAction func addPointButton(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        myPlaces.intermediatePlaces.append(myPlaces.tempPlace)
    }

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
    }
    
    @IBOutlet weak var finishPlaceTextEdit: UITextField!
    
    @IBAction func finishPlaceTextEditAction(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
        
    //MARK: When view was just load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Default position of a camera
        Map.setViewSize(googleView)
        Map.setCamera(place: myPlaces.defaultPlace)
        
        googleView = Map.mapView
        
        self.view.addSubview(googleView)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        myPlaces.tempPlace = Place(name: place.name, address: place.formattedAddress!, zoom: 11)
        Map.getLocation(address: myPlaces.tempPlace.address, getCoordinate: { (coordinates) in
            myPlaces.tempPlace.location = coordinates
            Map.setCamera(place: myPlaces.tempPlace)
        })
        
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

