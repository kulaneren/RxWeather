//
//  Url+Extensions.swift
//  RxWeather
//
//  Created by eren kulan on 23/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city),uk&appid=7d2dd8c9c5578b741c7735ad3f0d39ea&units=imperial")
    }
}
