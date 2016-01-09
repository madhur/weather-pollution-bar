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
       
    static func fetch(pollutionCallback: (Pollution?) -> Void)
    {
        let stationId = 798
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        
        let url = String(format: Constants.POLLUTION_URL, stationId, dateStr)
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
                    //PollutionView.pollution = pollution
                    //print(PollutionView.pollution!)
                    pollutionCallback(pollution)
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

