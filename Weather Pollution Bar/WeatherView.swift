//
//  WeatherView.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 06 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class WeatherView: NSViewController {
    
    var weather:Weather?
    let test:String? = "test77789"
    var futureWeather: [FutureWeather]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.willChangeValueForKey("weather")
        WeatherFetcher.fetchCurrent(currentWeatherCallback)
        WeatherFetcher.fetchFuture(futureWeatherCallback)
        //self.didChangeValueForKey("weather")
    }
    
    override var nibName : String{
        return "WeatherView"
    }
    
    var currentWeatherCallback =
    {
        (weather: Weather?) in
        
        print(weather)
        
    }
    
    var futureWeatherCallback =
    {
        (futureWeather: [FutureWeather]?) in
        
        print(futureWeather)
        
    }
    
}
