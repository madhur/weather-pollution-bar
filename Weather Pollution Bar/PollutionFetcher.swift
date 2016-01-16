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
        let stationId = AppPreferences.PollutionId
        if stationId == nil || stationId?.count == 0
        {
            print("not fetching pollution for default")
            pollutionCallback(nil)
            return
        }
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        
        let url = String(format: Constants.POLLUTION_URL, stationId![0] as! Int, dateStr)
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
            print("error while decoding json for pollution")
            return nil
        }
        
        let aqiDict = pollutionDict["aqi"] as! NSDictionary
        
        if aqiDict["param"] as! String == "N/A"
        {
            print("n/a found for param")
            return nil
        }
        
        let dateStr = pollutionDict["date"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy hh:mm a"
        
        let pollutionDate = dateFormatter.dateFromString(dateStr)
        
        let pollution: Pollution = Pollution(
            updatedTime: pollutionDict["date"] as! String,
            updatedLong: Int((pollutionDate?.timeIntervalSince1970)!),
            qualityIndex:  aqiDict["value"] as! Double,
            suggestion: "",
            pollutionColor: NSColor.blackColor()
            )
        
        return pollution
        
    }
    
}

