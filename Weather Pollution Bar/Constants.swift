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
    
    static let POLLUTION_URL="http://164.100.160.234:9000/metrics/station/%d?d=%@"
    
    static let WEATHER_API_KEY="fd8e51a8a23d22e2f1fb6733ff473fcd"
    
    
    static let WEATHER_MAPPING =  [
    "01d": "clear_sky", "01n": "clear_sky_night" , "02d": "few_clouds", "02n": "few_clouds_night", "03d": "scattered_clouds", "03n": "scattered_clouds", "04d": "broken_clouds", "04n": "broken_clouds", "09d": "shower rain", "09n": "shower rain", "10d": "rainy",
    "10n": "rainy", "11d": "thunderstorm", "11n":"thunderstorm", "13d":"snow" ,"13n": "snow", "50d": "mist", "50n":"mist"
    ]
    
    static let ADVISORY = [
        "Minimal impact",
        "Minor breathing discomfort to sensitive people",
        "Breathing discomfort to the people with lungs, asthma and heart diseases",
        "Breathing discomfort to most people on prolonged exposure",
        "Respiratory illness on prolonged exposure",
        "Affects healthy people and seriously impacts those with existing diseases"
    ]
    
    
}

struct Defaults
{
    static let UNITS = "units"
    static let CITY_ID = "city_id"
    static let SHOW_FUTURE_WEATHER = "show_future_weather"
    static let SYNC_INTERVAL = "sync_interval"
}

