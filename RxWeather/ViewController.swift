//
//  ViewController.swift
//  RxWeather
//
//  Created by eren kulan on 23/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var txtCityName: UITextField!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtCityName.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.txtCityName.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    }else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
        // For making the fecth every time
        //        self.txtCityName.rx.value
        //            .subscribe(onNext: { city in
        //                if let city = city {
        //                    if city.isEmpty {
        //                        self.displayWeather(nil)
        //                    }else {
        //                        self.fetchWeather(by: city)
        //                    }
        //                }
        //            }).disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?){
        //        DispatchQueue.main.async {
        if let weather = weather {
            self.lblTemperature.text = "\(weather.temp) ℉"
            self.lblHumidity.text = "\(weather.humidity)"
        }else {
            self.lblTemperature.text = ""
            self.lblHumidity.text = ""
        }
        //        }
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
        //  With error caching - Also this is V2 version of the load<T> func in URLRequest+extension
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            // RETRY
            .retry(3)
            .catchError {error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
        }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        /*  with driver
         let search = URLRequest.load(resource: resource)
         .observeOn(MainScheduler.instance)
         //.catchErrorJustReturn(WeatherResult.empty)
         .asDriver(onErrorJustReturn: WeatherResult.empty)
         */
        
        
        search.map { "\($0.main.temp) ℉" }
            .drive(self.lblTemperature.rx.text)
            .disposed(by: disposeBag)
        // Version 1 with bind - Driver doesn't have .bind func but driver has drive
        //        search.map { "\($0.main.temp) ℉" }
        //            .bind(to: self.lblTemperature.rx.text)
        //            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity)" }
            .drive( self.lblHumidity.rx.text)
            .disposed(by: disposeBag)
        
        // without Binding
        //        URLRequest.load(resource: resource)
        //            .observeOn(MainScheduler.instance)
        //            .catchErrorJustReturn(WeatherResult.empty)
        //            .subscribe(onNext: { result in
        //                let weather = result.main
        //                self.displayWeather(weather)
        //            }).disposed(by: disposeBag)
        
    }
}

