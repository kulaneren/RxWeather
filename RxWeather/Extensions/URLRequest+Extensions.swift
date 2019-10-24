//
//  URLRequest+Extensions.swift
//  RxWeather
//
//  Created by eren kulan on 23/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    // V2 checking repsponse code
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
        }.map { response, data -> T in
            if 200..<300 ~= response.statusCode{
                return try JSONDecoder().decode(T.self, from: data)
            }else {
                throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }
        }.asObservable()
    }
    
    /* V1 without error manangemnet
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let urlRequest = URLRequest(url: url)
                return URLSession.shared.rx.data(request: urlRequest)
        }.map { data -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
    */
}
