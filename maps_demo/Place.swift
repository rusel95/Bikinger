//
//  Place.swift
//  maps_demo
//
//  Created by Admin on 22.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import GoogleMaps

class Place {
    
    var name = String()
    var address = String()
    var zoom: Float
    var location = CLLocationCoordinate2D()
    
    init(name: String, address: String, zoom: Float){
        self.name = name
        self.address = address
        self.zoom = zoom
        self.location = self.getLocation()
        
    }
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
    
    func getLocation() -> CLLocationCoordinate2D {
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
                    print(self.location, self.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                }
                
            } catch {
                print("Error")
            }
        }
        
        task.resume()
        return tempLocation
    }
    
}
    //MARK: An array of Places
    let defaultPlace = Place(name: "Babylon center", location: CLLocationCoordinate2DMake(48.486916, 35.063890), zoom: 14)
    
    //var startPlace = Place()
    var intermediatePlaces = [Place(name: "init.dp.ua", location: CLLocationCoordinate2DMake(48.460174, 35.043961), zoom: 17),
                              Place(name: "Мост-Сити", location: CLLocationCoordinate2DMake(48.467262, 35.051122), zoom: 16),
                              Place(name: "ДИИТ", location: CLLocationCoordinate2DMake(48.435387, 35.046489), zoom: 16)]
    //var finishPlace = Place()
