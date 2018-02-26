//
//  GeolocationService.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

public typealias Coordinate = CLLocationCoordinate2D

class GeolocationService {
    
    private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 150
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        return manager
    }()
    
    private(set) var authorized: Driver<Bool>
    private(set) var currentLocation: Driver<Coordinate>
    
    private let disposeBag = DisposeBag()
    
    init() {
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx_didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map { [.authorizedAlways, .authorizedWhenInUse].contains($0) }
    
        currentLocation = locationManager.rx_didUpdateLocations
            .flatMapLatest { coordinates -> Observable<Coordinate> in
                guard let lastCoordinate = coordinates.last?.coordinate else { return Observable.empty() }
                return Observable.just(lastCoordinate)
        }.asDriver(onErrorJustReturn: Constants.visit_TechHuddle)
    
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate Rx encapsulation
class CLLocationManagerProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    private var manager: CLLocationManager
    
    init(_ manager: CLLocationManager) {
        self.manager = manager
        super.init(parentObject: manager, delegateProxy: CLLocationManagerProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { CLLocationManagerProxy($0) }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

extension CLLocationManager {
    private var rx_delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return CLLocationManagerProxy.proxy(for: self)
    }
    
    public var rx_didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        let selector = #selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:))
        return rx_delegate.methodInvoked(selector)
            .map { params in
                guard let parameter = params[1] as? Int32,
                    let status = CLAuthorizationStatus(rawValue: parameter) else {
                        return .notDetermined
                }
                return status
            }
            .startWith(CLLocationManager.authorizationStatus())
            .share(replay: 1)
    }
    
    public var rx_didUpdateLocations: Observable<[CLLocation]> {
        let selector = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return rx_delegate.methodInvoked(selector)
            .map { params in
                return params[1] as? [CLLocation] ?? []
            }
            .share(replay: 1)
    }
}
