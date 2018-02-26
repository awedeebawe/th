//
//  Constants.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 24.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import Foundation

struct Constants {
    
    /// List tab title
    static let listTab = "LIST"
    
    /// Map tab title
    static let mapTab = "MAP"
    
    /// Geolocation radius
    static let radius: Double = 750
    
    /// Backup geolocation
    static let visit_TechHuddle = Coordinate(latitude: 42.6698567, longitude: 23.3531379)
    
    /// Basic Network error
    static let networkError = "Failed to fetch data"
    
    /// Error alert title
    static let alertTitle = "Error"
    
    /// Error alert close button
    static let alertClose = "Close"
    
    /// No Geolocation warning
    static let noGeolocationEmoji = "🛰"
    static let noGeolocation = "\n\nGeolocation not available"
    static let noGeolocationSubtitle = "\n(You should enable it from [⚙️ Settings])"

    /// No Bars nearby warning
    static let noPlacesEmoji = "🤯"
    static let noPlaces = "\n\nNo bars near you"
}
