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
    
    
    static func fetchCurrent(currentWeatherCallback : @escaping (Weather?)-> Void, units: String)
    {
        let cityId = AppPreferences.CityId
//        let cityIdBlr = 1277333
  
        let weatherUrlRequest = String(format: Constants.CURRENT_WEATHER_URL, cityId , Constants.WEATHER_API_KEY, getUrlParam(units: units))
        let weatherUrl = NSURL(string: weatherUrlRequest)
        let request = NSURLRequest(url: weatherUrl! as URL)
        
        let weatherTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
        
                    if error != nil
                    {
                        //There was an error getting the data
                        print(error)
                        
                    }
                    else if data != nil
                    {
                        let weatherObj = currentWeatherFromJSON(data: data as NSData?)
                        
                        OperationQueue.main.addOperation({
                            currentWeatherCallback(weatherObj)
                        })
                                                
                    }
            
            })
        
    
        weatherTask.resume()
    }
    
    static func fetchFuture(futureWeatherCallback: @escaping ([FutureWeather]?) -> Void, units: String)
    {
        let cityId = AppPreferences.CityId
        
        let weatherUrlRequest = String(format: Constants.FUTURE_WEATHER_URL, cityId , Constants.WEATHER_API_KEY, getUrlParam(units: units))
        let weatherUrl = NSURL(string: weatherUrlRequest)
        let request = NSURLRequest(url: weatherUrl! as URL)
        
        let weatherTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
                
                if error != nil
                {
                    //There was an error getting the data
                    print(error)
                    
                }
                else if data != nil
                {
                    let futureWeatherList = futureWeatherFromJSON(data: data as NSData?)
                    
                    OperationQueue.main.addOperation({
                        futureWeatherCallback(futureWeatherList)
                        })
                    
                }
                
        })
        
        
        weatherTask.resume()
        
    }
    
    static func futureWeatherFromJSON(data: NSData?) -> [FutureWeather]?
    {
        var dict:NSDictionary?
        do
        {
            dict = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        }
        catch
        {
            print("Error while decoding json for future weather")
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
                temperatureIcon: weatherDict[0]["icon"] as! String,
                updatedLong: futureDict["dt"] as! Int
                
            )
            
            futureWeatherList.append(futureWeather)
            
            
        }
        
        return futureWeatherList
        
    }
    
    static func getUrlParam(units: String) -> String
    {
        if units == "C"
        {
            return "metric"
        }
        else if units == "F"
        {
            return "imperial"
        }
        
        return "metric"
    }
    
    
    static func currentWeatherFromJSON(data: NSData?) -> Weather?
    {
        var dict:NSDictionary?
        do
        {
            dict = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        }
        catch
        {
            print("Error while decoding json for current weather")
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
            updatedTime: "",
            updatedLong: dict!["dt"] as! Int,
            todayWeather:todayWeather,
            location: dict!["name"] as! String
        )
        
        return weather
        
    }
    
    
}
