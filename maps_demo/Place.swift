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
    var location = CLLocationCoordinate2D()
    var zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float){
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}
