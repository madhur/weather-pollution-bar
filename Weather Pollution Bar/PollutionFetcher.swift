//
//  PollutionFetcher.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 04 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation
import Cocoa

class PollutionFetcher
{
    static var pollution: Pollution?
    
    static func fetch()
    {
        let stationId = 798
        
        let url = String(format: Constants.POLLUTION_URL, stationId)
        let request = NSURL(string: url)
        let urlRequest = NSURLRequest(URL: request!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest,
            completionHandler: { (data, response, error) -> Void in
            
                if error != nil
                {
                    print(error)
                }
                else if(data != nil)
                {
                    let pollution = getPollutionFromJSON(data!)
                    self.pollution = pollution
                    print(self.pollution)
                }
                
        })
        
        task.resume()
    
    }
    
    static func getPollutionFromJSON(data: NSData) -> Pollution?
    {
        let pollutionDict: NSDictionary
        
        do
        {
            pollutionDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
        catch
        {
            print("error while decoding json")
            return nil
        }
        
        let aqiDict = pollutionDict["aqi"] as! NSDictionary
        
        let pollution: Pollution = Pollution(
            updatedTime: "",
            updatedLong: Int(NSDate().timeIntervalSince1970),
            qualityIndex:  aqiDict["value"] as! Double,
            suggestion: "",
            pollutionColor: NSColor.blackColor()
            )
        
        return pollution
        
    }
    
}

