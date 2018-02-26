//
//  BarsMapViewController.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class BarsMapViewController: UIViewController {
    
    var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        return mapView
    }()
    
    var noGeolocationLabel: UILabel = UILabel.createNotificationLabel(withText: Constants.noGeolocation,
                                                                      andSubtitle: Constants.noGeolocationSubtitle,
                                                                      andEmoji: Constants.noGeolocationEmoji)
    
    var viewModel: ViewModel?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(noGeolocationLabel)
        center(noGeolocationLabel)
        
        view.insertSubview(mapView, aboveSubview: noGeolocationLabel)
        mapView.delegate = self
        stretch(mapView)
        
        // View model bindings
        viewModel?.geolocationService.authorized
            .map { !$0 }
            .drive(mapView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel?.geolocationService.currentLocation
            .drive(onNext: { [weak mapView] coordinate in
                let region = MKCoordinateRegionMakeWithDistance(coordinate, Constants.radius, Constants.radius)
                mapView?.setRegion(region, animated: true)
                mapView?.setCenter(coordinate, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel?.places
            .do(onNext: { [weak mapView] _ in
                // clean the map
                if let allAnnotations = mapView?.annotations {
                    allAnnotations.forEach {
                        if !($0 is MKUserLocation) { mapView?.removeAnnotation($0) }
                    }
                }
            })
            .drive(onNext: { [weak mapView] places in
                places.forEach { place in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = place.geometry.geolocation
                    annotation.title = place.name
                    annotation.subtitle = "\(place.geometry.distance)m"
                    mapView?.addAnnotation(annotation)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapView delegate (no need to create an Rx extension :) )
extension BarsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseIdentifier = "barLocation"
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = true
            
            return annotationView
        }
        
        annotationView.annotation = annotation
        
        return annotationView
    }
}
