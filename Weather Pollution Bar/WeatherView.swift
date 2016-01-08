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
    var futureWeather: [FutureWeather]?

    @IBOutlet weak var currentTemp: NSTextField!
    @IBOutlet weak var currentUnit: NSTextField!
    @IBOutlet weak var currentIcon: NSImageView!
    @IBOutlet weak var currentDescription: NSTextField!
    
    @IBOutlet weak var dayLabel1: NSTextField!
    @IBOutlet weak var dayLabel2: NSTextField!
    @IBOutlet weak var dayLabel3: NSTextField!
    
    @IBOutlet weak var dayMaxTemp1: NSTextField!
    @IBOutlet weak var dayMaxTemp2: NSTextField!
    @IBOutlet weak var dayMaxTemp3: NSTextField!
    
    var dayMax: [NSTextField]?
    var dayMin: [NSTextField]?
    var dayIcon: [NSImageView]?
    var dayLabel: [NSTextField]?
    
    @IBOutlet weak var dayMinTemp1: NSTextField!
    @IBOutlet weak var dayMinTemp2: NSTextField!
    @IBOutlet weak var dayMinTemp3: NSTextField!
    
    
    @IBOutlet weak var dayIcon1: NSImageView!
    @IBOutlet weak var dayIcon2: NSImageView!
    @IBOutlet weak var dayIcon3: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        dayMax = [dayMaxTemp1, dayMaxTemp2, dayMaxTemp3]
        dayMin  = [dayMinTemp1, dayMinTemp2, dayMinTemp3]
        dayIcon = [dayIcon1, dayIcon2, dayIcon3]
        dayLabel = [dayLabel1, dayLabel2, dayLabel3]
        
        updateWeather()
      
    }
    
    override var nibName : String{
        return "WeatherView"
    }
    
    func updateWeather()
    {
        WeatherFetcher.fetchCurrent(currentWeatherCallback)
        WeatherFetcher.fetchFuture(futureWeatherCallback)

    }
    
    
    var currentWeatherCallback: Weather? -> Void { return
        {
            (weather: Weather?) in
            print(weather)
            self.currentTemp.stringValue = Int((weather?.todayWeather?.temperature.current)!).description
            self.currentUnit.stringValue = AppPreferences.Units
            self.currentDescription.stringValue = (weather?.todayWeather?.title)!
            self.currentIcon.image = NSImage(named: Constants.WEATHER_MAPPING[(weather?.todayWeather?.temperatureIcon)!]!)
            
            
        }
    }
    
    
    var futureWeatherCallback : [FutureWeather]? -> Void
        { return
            {
    
                (futureWeather: [FutureWeather]?) in
                
               var i = 0
               for (index, weather) in (futureWeather?.enumerate())!
               {
                    if index==0 && WeatherView.checkPastDate(weather.updatedLong)
                    {
                        continue
                    }
                    if i == 3
                    {
                        break
                    }
                
                    self.dayMax?[i].stringValue = Int(weather.temperature.max).description
                    self.dayMin?[i].stringValue = Int(weather.temperature.min).description
                    self.dayIcon?[i].image = NSImage(named: Constants.WEATHER_MAPPING[weather.temperatureIcon]!)
                    self.dayLabel?[i].stringValue = WeatherView.getWeekString(weather.updatedLong)
                
                    i = i + 1
                }
        
                print(futureWeather)
            }
        
        }
    
    static func checkPastDate(dt: Int) -> Bool
    {
       
        let currentDay = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        let weatherday = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate(timeIntervalSince1970: Double(dt)))
        
        print(currentDay.day)
        print(weatherday.day)
        if currentDay.day - weatherday.day == 0
        {
            
            return false
        }
        
        
        return true
    }
    
    static func getWeekString(dt: Int) -> String
    {
        let today = NSDate()
        let weatherDate = NSDate(timeIntervalSince1970: Double(dt))
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        if(dateFormatter.stringFromDate(today) == dateFormatter.stringFromDate(weatherDate))
        {
            return "Today"
        }
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
}
