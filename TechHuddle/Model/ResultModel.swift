//
//  ResultModel.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import Foundation
import CoreLocation

struct ResponseJSON: Codable {
    var main:ResultsJSON?
}

public struct ResultsJSON: Codable {
    var results:[Place]?
}

public struct Place: Codable {
    var id: String?
    var name: String?
    var geometry: Geometry
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case geometry = "geometry"
    }
}

public struct Geometry: Codable {
    private var location: Location
    
    var geolocation: Coordinate {
        return Coordinate(latitude: location.lat, longitude: location.lng)
    }
    
    var distance: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case location = "location"
    }
}

public struct Location: Codable {
    var lat: Double
    var lng: Double
}
