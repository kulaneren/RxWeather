//
//  WeatherResult.swift
//  RxWeather
//
//  Created by eren kulan on 23/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

extension WeatherResult {
//    static var empty =  WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
