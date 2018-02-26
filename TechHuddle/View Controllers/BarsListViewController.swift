//
//  BarsListViewController.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BarsListViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "placeCell")
        
        return tableView
    }()
    
    var noPlacesLabel: UILabel = UILabel.createNotificationLabel(withText: Constants.noPlaces,
                                                                 andEmoji: Constants.noPlacesEmoji)
    
    var viewModel: ViewModel?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(noPlacesLabel)
        center(noPlacesLabel)
        
        view.insertSubview(tableView, aboveSubview: noPlacesLabel)
        stretch(tableView)
        
        // View model bindings
        viewModel?.places
            .map { $0.count == 0 }
            .asDriver()
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel?.places
            .drive(tableView.rx.items(cellIdentifier: "placeCell")) { (row, element, cell) in
                cell.textLabel?.text = element.name
                let distanceLabel = UILabel.createDistanceLabel()
                distanceLabel.text = "\(element.geometry.distance)m"
                cell.accessoryView = distanceLabel
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Place.self)
            .subscribe(onNext: { place in
                let lat = place.geometry.geolocation.latitude
                let lng = place.geometry.geolocation.longitude
                
                if UIApplication.shared
                    .canOpenURL(URL(string:"comgooglemaps://")!) {
                    UIApplication.shared
                        .open(URL(string: "comgooglemaps://?center=\(lat),\(lng)&zoom=14&views=traffic&q=loc:\(lat),\(lng)")!,
                                              options: [:],
                                              completionHandler: nil)
                } else {
                    print("Can't use comgooglemaps://")
                    UIApplication.shared
                        .open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(lng)&zoom=14&views=traffic")!,
                                              options: [:],
                                              completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.error
            .drive(self.rx.error)
            .disposed(by: disposeBag)
    }
    
    

}
