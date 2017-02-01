//
//  Place.swift
//  maps_demo
//
//  Created by Admin on 22.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import GoogleMaps

//MARK: An array of Places
class Places {
    var defaultPlace = Place(name: "Babylon center", location: CLLocationCoordinate2DMake(48.486916, 35.063890), zoom: 12)
    
    var tempPlace = Place()
    
    var startPlace = Place()
    var finishPlace = Place()
    
    var intermediatePlaces = [Place(name: "init.dp.ua", location: CLLocationCoordinate2DMake(48.460174, 35.043961), zoom: 12),
                              Place(name: "Мост-Сити", location: CLLocationCoordinate2DMake(48.467262, 35.051122), zoom: 12),
                              Place(name: "ДИИТ", location: CLLocationCoordinate2DMake(48.435387, 35.046489), zoom: 12)]
    
    func ifAddNewPlacePossible(_ viewController: UIViewController) -> Bool {
        if intermediatePlaces.count < 5 {
            return true
        } else {
            //need to add attension
            print("You can`t add more points")
            
            createAlert(viewController, "Warning", "You can`t add more than 5 places! Delete some place to add a new one.")
            
            return false
        }
    }
    
    private func createAlert(_ viewController: UIViewController, _ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Продолжить", style: UIAlertActionStyle.default , handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

class Place {
    
    var name = String()
    var address = String()
    var zoom: Float
    var location = CLLocationCoordinate2D()
    
    init() {
        name = ""
        address = ""
        zoom = 1
        location = CLLocationCoordinate2DMake(0, 0)
    }
    
    //Initializing for intermediate Places
    init(name: String, address: String, zoom: Float){
        self.name = name
        self.address = address
        self.zoom = zoom
        //        self.getLocation(getCoordinate: { (coordinate) in
        //            self.location = coordinate
        //            print("Init log")
        //            print(self.address, self.location)
        //        })
        
    }
    
    //Initializing for default Places in storage
    init(name: String, location: CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
    
    private func getLocation(getCoordinate:@escaping (_ coordinate:(CLLocationCoordinate2D)) -> Void) -> Void {
        var tempLocation = CLLocationCoordinate2D()
        
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.address)&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
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
                    print(self.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, tempLocation)
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


