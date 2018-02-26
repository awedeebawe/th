//
//  NetworkService.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 23.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result {
    case loading
    case success(withData: Data)
    case error(withMessage: String)
    
    public func getSuccess() -> Data? {
        guard case let .success(data) = self else { return nil }
        return data
    }
    
    public func getError() -> String? {
        guard case let .error(message) = self else { return nil }
        return message
    }
}

class NetworkService {
    private static var googleApiKey: String {
        return "AIzaSyBhDWDCmVe6oVOWUoR-IR9w8pncHsoDrk4"
    }
    private static var baseUrl: String {
        return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" + parameters.map {
            "\($0.key)=\($0.value)"
            }
            .joined(separator: "&")
    }
    
    private static var parameters: [String: String] {
        return [
                "radius": "\(Constants.radius)",
                "types": "bar",
                "key": googleApiKey
                ]
    }
    
    public let coordinates = PublishSubject<(lat: Double, lon: Double)>()

    public var result: Observable<Result> {
        return coordinates.asObservable()
            .flatMap { coordinates -> Observable<Result> in
                return Observable.create { observer in
                    
                    let urlString = NetworkService.baseUrl + "&location=\(coordinates.lat),\(coordinates.lon)"
                    let request = URLRequest(url: URL(string: urlString)!)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data else {
                            observer.onNext(Result.error(withMessage: Constants.networkError))
                            observer.onError(error ?? RxCocoaURLError.unknown) // cut the stream on error
                            return
                        }
                        
                        observer.onNext(Result.success(withData: data))
                        observer.onCompleted() // cut the stream on success
                        
                    }
                    
                    task.resume()
                    
                    return Disposables.create {
                        task.cancel()
                    }
                }
                .startWith(.loading)
                .share(replay: 1)
        }
    }
}
