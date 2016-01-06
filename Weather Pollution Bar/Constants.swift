//
//  Constants.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation

struct Constants
{
    static let TWITTER_URL = "https://twitter.com/madhur25"
    static let GIT_URL = "https://github.com/madhur/weather-pollution-bar"
    static let HOME_URL = "http://madhur.co.in"
    static let VERSION = "Version: %@"
    
    static let UNITS = ["C", "F"]
    static let SYNC_INTERVAL = [5, 10, 30, 60]
    
    static let FUTURE_WEATHER_URL="http://api.openweathermap.org/data/2.5/forecast/daily?id=%d&mode=json&appid=%@&cnt=4&units=metric"
    
    static let CURRENT_WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=%d&mode=json&appid=%@&units=metric"
    
    static let POLLUTION_URL="http://164.100.160.234:9000/metrics/station/{}?d={}&h={}"
    
    static let WEATHER_API_KEY="fd8e51a8a23d22e2f1fb6733ff473fcd"
    
}

struct Defaults
{
    static let UNITS = "units"
    static let CITY_ID = "city_id"
    static let SHOW_FUTURE_WEATHER = "show_future_weather"
    static let SYNC_INTERVAL = "sync_interval"
}

