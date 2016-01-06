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
    
    static func fetch()
    {
        
        let weatherUrlRequest = String(format: Constants.CURRENT_WEATHER_URL, 524901 , Constants.WEATHER_API_KEY)
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
                        let weather = weatherFromJSON(data)
                        WeatherFetcher.weather = weather
                        
                    }
            
            })
        
    
        weatherTask.resume()
    }
    
    
    static func weatherFromJSON(data: NSData?) -> Weather?
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
        
        
        
        return nil
        
    }
    
    
}