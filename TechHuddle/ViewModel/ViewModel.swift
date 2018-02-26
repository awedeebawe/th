//
//  ViewModel.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class ViewModel {
    
    let geolocationService = GeolocationService()
    
    private let networkService = NetworkService()
    
    private let disposeBag = DisposeBag()
    
    /// Error?
    public let error: Driver<String>
    
    /// Google Places API results
    public let places: Driver<[Place]>
    
    init() {
        let networkResult = networkService.result
            .map { $0.getSuccess() }
        let currentAuthorizationStatus = geolocationService.authorized
            .asObservable()
            .share(replay: 1)
        let currentLocationObservable = geolocationService.currentLocation
            .asObservable()
            .share(replay: 1)

        /// Bind the geolocation change to the network service
        currentLocationObservable
            .map { return (lat: $0.latitude, lon: $0.longitude) }
            .bind(to: networkService.coordinates)
            .disposed(by: disposeBag)
        
        error = networkService.result
            .map { $0.getError() }
            .flatMap { error -> Observable<String> in
                guard let error = error else { return Observable.empty() }
                return Observable.just(error)
            }
            .asDriver(onErrorJustReturn: "")

        places = Observable.combineLatest(currentAuthorizationStatus, networkResult, currentLocationObservable) { (authorized: $0, result: $1, location: $2) }
            .flatMap { combination -> Observable<[Place]> in
                // check if geolocation is authorized
                guard combination.authorized else { return Observable.just([]) }
                
                // get the network result
                guard let result = combination.result else { return Observable.just([]) }
                
                do {
                    let json = try JSONDecoder().decode(ResultsJSON.self, from: result)
                    let places = json.results?.map({ place -> Place in
                        var mutablePlace = place
                        
                        let placeLocation = CLLocation(latitude: place.geometry.geolocation.latitude,
                                                       longitude: place.geometry.geolocation.longitude)
                        
                        let userLocation = CLLocation(latitude: combination.location.latitude,
                                                      longitude: combination.location.longitude)
                        mutablePlace.geometry.distance = Int(placeLocation.distance(from: userLocation))
                        
                        return mutablePlace
                    }).sorted(by: { $0.geometry.distance < $1.geometry.distance})
                    return Observable.just(places ?? [])
                } catch {
                    return Observable.just([])
                }
            }
            .asDriver(onErrorJustReturn: [])
            .startWith([])
    }
}
