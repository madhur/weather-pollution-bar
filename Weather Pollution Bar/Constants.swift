//
//  Constants.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation
import Cocoa

struct Constants
{
    static let TWITTER_URL = "https://twitter.com/madhur25"
    static let GIT_URL = "https://github.com/madhur/weather-pollution-bar"
    static let HOME_URL = "http://madhur.co.in"
    static let VERSION = "Version: %@"
    
    static let UNITS = ["C", "F"]
    static let SYNC_INTERVAL = [5, 10, 30, 60]
    static let ICON_TYPE = ["Static", "Temperature Value", "Dynamic icon"]
    
    static let FUTURE_WEATHER_URL="http://api.openweathermap.org/data/2.5/forecast/daily?id=%d&mode=json&appid=%@&cnt=4&units=%@"
    
    static let CURRENT_WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=%d&mode=json&appid=%@&units=%@"
    
    static let POLLUTION_URL="http://164.100.160.234:9000/metrics/station/%d?d=%@"
    
    static let WEATHER_API_KEY="370d27da629713125df5d1e53a937e67"
    
    static let UPDATE_NOTIFICATION = "in.co.madhur.update_notification"
    
    
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
    static let ICON_TYPE = "icon_type"
    static let SYNC_INTERVAL = "sync_interval"
}

func getReadableTime(updatedTime: Int) -> String
{
    let currentDate = NSDate()
    let updatedDate = NSDate(timeIntervalSince1970: NSTimeInterval(updatedTime))
    
    let components = NSCalendar.currentCalendar().components([.Day, .Hour, .Minute, .Second], fromDate: updatedDate, toDate: currentDate, options: [])
    
    
    let strFormat = "Updated: %@"
    var strVal = ""
    
    if components.day > 0
    {
        if components.day == 1
        {
            strVal = String(components.day) + " day ago"
        }
        else
        {
            strVal = String(components.day) + " days ago"
        }
    }
    else if components.hour > 0
    {
        if components.hour == 1
        {
            strVal = String(components.hour) + " hour ago"
        }
        else
        {
            strVal = String(components.hour) + " hours ago"
        }
    }
    else if components.minute > 0
    {
        if components.minute == 1
        {
            strVal = String(components.minute) + " minute ago"
        }
        else
        {
            strVal = String(components.minute) + " minutes ago"
        }
    }
    else if components.second > 0
    {
        if components.second == 1
        {
            strVal = String(components.second) + " second ago"
        }
        else
        {
            strVal = String(components.second) + " seconds ago"
        }
    }
    
    return String(format: strFormat, strVal)
    
}

