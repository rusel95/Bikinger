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
        //mainView = googleView
        
        //self.view.addSubview(mainView)
        //self.view.addSubview(startPlaceTextEdit)
        //self.view.addSubview(finishPlaceTextEdit)
    }
    
    
    
    
    //MARK: next/previos buttons functions
    func next() {
        if currentPlaceId < intermediatePlaces.count - 1 {
            currentPlaceId += 1
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
        
        let tempPoint = Place(name: place.name, address: place.formattedAddress!, zoom: 11)
        
        self.getLocation(address: tempPoint.address) { (coordinate) in
            tempPoint.location = coordinate
            print("Init log")
            print(tempPoint.address, tempPoint.location, tempPoint.location )
            
            intermediatePlaces.append(tempPoint)
            intermediatePlaces[intermediatePlaces.endIndex - 1].setCamera(mapView: self.mapView!)
            
            self.dismiss(animated: true, completion: nil)
        }
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
    
    private func getLocation(address: String, getCoordinate:@escaping (_ coordinate:(CLLocationCoordinate2D)) -> Void) -> Void {
        var tempLocation = CLLocationCoordinate2D()
        
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                    
                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                    
                    tempLocation.longitude = lon
                    tempLocation.latitude = lat
                    
                    print("GetLocation log: ")
                    print(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, tempLocation)
                }
                
            } catch {
                print("Error")
            }
            
            //escaping closure
            getCoordinate(tempLocation)
        }
        
        task.resume()
        
        //escaping closure
        //getCoordinate(tempLocation)
    }

}

