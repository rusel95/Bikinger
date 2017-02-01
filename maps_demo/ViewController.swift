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
    
    
    @IBAction func addPointButton(_ sender: Any) {
    }

    @IBAction func nextDestinationButton(_ sender: Any) {
        //Map.nextPoint()
    }
    
    @IBAction func previousDestinationButton(_ sender: Any) {
        //Map.previousPoint()
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
        Map.setViewPropertys(googleView)
        Map.setCamera(place: defaultPlace)
        
        googleView = Map.mapView
        
        self.view.addSubview(googleView)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let tempPoint = Place(name: place.name, address: place.formattedAddress!, zoom: 11)
        Map.getLocation(address: tempPoint.address, getCoordinate: { (coordinates) in
            tempPoint.location = coordinates
            intermediatePlaces.append(tempPoint)
            Map.setCamera(place: intermediatePlaces[intermediatePlaces.endIndex - 1])
            
            self.startPlaceTextEdit.text = intermediatePlaces[intermediatePlaces.endIndex - 1].address
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

