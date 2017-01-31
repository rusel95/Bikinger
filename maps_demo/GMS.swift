//
//  GMS.swift
//  maps_demo
//
//  Created by Admin on 31.01.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GMS {
    
    private var currentPlaceId = 0
    
    //MARK: next/previos buttons functions
    func nextPoint() {
        if currentPlaceId < intermediatePlaces.count - 1 {
            currentPlaceId += 1
            setCamera(place: intermediatePlaces[currentPlaceId])
        }
    }
    
    func previousPoint() {
        if currentPlaceId > 0 {
            currentPlaceId -= 1
            setCamera(place: intermediatePlaces[currentPlaceId])
        }
    }
    
    func setCamera(place: Place) {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
            mapView?.animate(to: GMSCameraPosition.camera(withTarget: place.location, zoom: place.zoom))
            CATransaction.commit()
            
            let marker = GMSMarker(position: place.location)
            marker.title = place.name
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
        }
    }
    
    func getLocation(address: String) { coordinate in
        tempPoint.location = coordinate
        print("Init log")
        print(tempPoint.address, tempPoint.location, tempPoint.location )
    }
    
    private func getLocation(address: String, getCoordinate:@escaping (_ coordinate:(CLLocationCoordinate2D)) -> Void) -> CLLocationCoordinate2D {
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
                print("Error while getting data from google maps")
            }
            
            //escaping closure
            getCoordinate(tempLocation)
        }
        
        task.resume()
    }
    
}
