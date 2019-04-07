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
    var statusMenuViewController: StatusMenuController?

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
    
    @IBOutlet weak var updatedLabel: NSTextField!
    
    var StatusView: StatusMenuController? {
        get {
            return statusMenuViewController
        }
        set(view) {
            statusMenuViewController = view
        }
    }
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
        let units  = AppPreferences.Units
        
        WeatherFetcher.fetchCurrent(currentWeatherCallback: currentWeatherCallback, units: units!)
        WeatherFetcher.fetchFuture(futureWeatherCallback: futureWeatherCallback, units: units!)

    }
    
    
    var currentWeatherCallback: (Weather?) -> Void { return
        {
            (weather: Weather?) in
            
            self.statusMenuViewController?.showWeather()
            
            //print(weather)
            print("got current weather")
            self.currentTemp.stringValue = Int((weather?.todayWeather?.temperature.current)!).description + Constants.DEG_SYMBOL
            self.currentUnit.stringValue = AppPreferences.Units!
            print(self.currentUnit.stringValue)
            self.currentDescription.stringValue = (weather?.todayWeather?.title)!
            
            let image = NSImage(named: Constants.WEATHER_MAPPING[(weather?.todayWeather?.temperatureIcon)!]!)
            //let image  = NSImage(named: (weather?.todayWeather?.temperatureIcon)!)
            image?.cacheMode = NSImage.CacheMode.never
            
            self.currentIcon.image = image
            
            if AppPreferences.IconType == Constants.ICON_TYPE[0]
            {
                let icon = NSImage(named: "statusIcon")
                icon!.size = NSSize.init(width: 18, height: 18)
                icon?.isTemplate = true
                self.statusMenuViewController?.statusItem.image = icon
                self.statusMenuViewController?.statusItem.title = nil
                
            }
            else if AppPreferences.IconType == Constants.ICON_TYPE[1]
            {
                self.statusMenuViewController?.statusItem.title = Int((weather?.todayWeather?.temperature.current)!).description
                self.statusMenuViewController?.statusItem.image = nil
            }
            else if AppPreferences.IconType == Constants.ICON_TYPE[2]
            {
                self.statusMenuViewController?.statusItem.title = nil
                
                let icon = NSImage(named: Constants.WEATHER_MAPPING[(weather?.todayWeather?.temperatureIcon)!]!)?.copy() as! NSImage
                icon.size = NSSize.init(width: 18, height: 18)
                icon.isTemplate = true
                icon.cacheMode = NSImage.CacheMode.never
                self.statusMenuViewController?.statusItem.image = icon
            }
                        
            self.statusMenuViewController?.weatherMenuItem.toolTip = getReadableTime(updatedTime: (weather?.updatedLong)!)
            
        }
    }
    
    
    var futureWeatherCallback : ([FutureWeather]?) -> Void
        { return
            {
    
                (futureWeather: [FutureWeather]?) in
                
               var i = 0
                for (index, weather) in (futureWeather?.enumerated())!
               {
                if index==0 && WeatherView.checkPastDate(dt: weather.updatedLong)
                    {
                        continue
                    }
                    if i == 3
                    {
                        break
                    }
                
                    self.dayMax?[i].stringValue = Int(weather.temperature.max).description + Constants.DEG_SYMBOL
                    self.dayMin?[i].stringValue = Int(weather.temperature.min).description + Constants.DEG_SYMBOL
                
                    let image = NSImage(named: Constants.WEATHER_MAPPING[weather.temperatureIcon]!)?.copy() as! NSImage
                    //let image = NSImage(named: weather.temperatureIcon)!
                image.cacheMode = NSImage.CacheMode.never
                    self.dayIcon?[i].image = image
                self.dayLabel?[i].stringValue = WeatherView.getWeekString(dt: weather.updatedLong)
                
                
                    i = i + 1
                }
        
                
            }
        
        }
    
    static func checkPastDate(dt: Int) -> Bool
    {
       
        let currentDay = NSCalendar.current.dateComponents([.day, .month, .year], from: NSDate() as Date)
        let weatherday = NSCalendar.current.dateComponents([.day, .month, .year], from: NSDate(timeIntervalSince1970: Double(dt)) as Date)
        
        
        
        if currentDay.day - weatherday.day == 0 {
            
            return false
        }
        
        
        return true
    }
    
    static func getWeekString(dt: Int) -> String
    {
        let today = NSDate()
        let weatherDate = NSDate(timeIntervalSince1970: Double(dt))
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        if(dateFormatter.string(from: today as Date) == dateFormatter.string(from: weatherDate as Date))
        {
            return "Today"
        }
        
        return dateFormatter.string(from: weatherDate as Date)
    }
    
}
