//
//  WeatherFetcher.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 04 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation
import Cocoa

class WeatherFetcher
{
    static var weather:Weather?
    static var futureWeather: [FutureWeather]?
    
    static func fetchCurrent()
    {
        
        let weatherUrlRequest = String(format: Constants.CURRENT_WEATHER_URL, 1277333 , Constants.WEATHER_API_KEY)
        let weatherUrl = NSURL(string: weatherUrlRequest)
        let request = NSURLRequest(URL: weatherUrl!)
        
        let weatherTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            {
                (data, response, error) -> Void in
        
                    if error != nil
                    {
                        //There was an error getting the data
                        print(error)
                        
                    }
                    else if data != nil
                    {
                         let weather = currentWeatherFromJSON(data)
                         WeatherFetcher.weather = weather
                         print(WeatherFetcher.weather!)
                        
                    }
            
            })
        
    
        weatherTask.resume()
    }
    
    static func fetchFuture()
    {
        
        let weatherUrlRequest = String(format: Constants.FUTURE_WEATHER_URL, 1277333 , Constants.WEATHER_API_KEY)
        let weatherUrl = NSURL(string: weatherUrlRequest)
        let request = NSURLRequest(URL: weatherUrl!)
        
        let weatherTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            {
                (data, response, error) -> Void in
                
                if error != nil
                {
                    //There was an error getting the data
                    print(error)
                    
                }
                else if data != nil
                {
                    let futureWeatherList = futureWeatherFromJSON(data)
                   
                    WeatherFetcher.futureWeather = futureWeatherList
                    print(WeatherFetcher.futureWeather!)
                    
                }
                
        })
        
        
        weatherTask.resume()
        
    }
    
    static func futureWeatherFromJSON(data: NSData?) -> [FutureWeather]?
    {
        var dict:NSDictionary?
        do
        {
            dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
        catch
        {
            print("Error while decoding json")
            return nil
        }

        var futureWeatherList: [FutureWeather] = []
        
        let weatherList = dict!["list"] as! [NSDictionary]
        
        for futureDict in weatherList
        {
            let mainDict = futureDict["temp"] as! NSDictionary
            let weatherDict = futureDict["weather"] as! [NSDictionary]
            
            let temperature = Temperature(
                min: mainDict["min"] as! Double,
                max: mainDict["max"] as! Double,
                current: mainDict["day"] as! Double,
                degree: "C"
            )
            
            let futureWeather = FutureWeather(
                title: weatherDict[0]["main"] as! String,
                temperature: temperature,
                description: weatherDict[0]["description"] as! String,
                temperatureIcon: weatherDict[0]["icon"] as! String
                
            )
            
            futureWeatherList.append(futureWeather)
            
            
        }
        
        return futureWeatherList
        
    }
    
    
    static func currentWeatherFromJSON(data: NSData?) -> Weather?
    {
        var dict:NSDictionary?
        do
        {
            dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
        catch
        {
            print("Error while decoding json")
            return nil
        }
        
        let temperatureDict = dict!["main"] as! NSDictionary
        let weatherDict = dict!["weather"] as! [NSDictionary]
       
        if weatherDict.count > 0
        {
            
        }
        
        let temperature = Temperature(
            min: temperatureDict["temp_min"] as! Double,
            max: temperatureDict["temp_max"] as! Double,
            current: temperatureDict["temp"] as! Double,
            degree: "C"
        )
        
        let todayWeather = TodayWeather(
            title: weatherDict[0]["main"] as! String,
            temperature: temperature,
            description: weatherDict[0]["description"] as! String,
            temperatureIcon: weatherDict[0]["icon"] as! String
        )

        let weather : Weather = Weather(
            updatedTime:"",
            updatedLong: dict!["dt"] as! Int,
            todayWeather: todayWeather,
           // futureWeatherList: nil,
            location: dict!["name"] as! String
        )
        
        return weather
        
    }
    
    
}