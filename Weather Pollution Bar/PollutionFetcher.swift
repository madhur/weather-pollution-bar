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
       
    static func fetch(pollutionCallback: @escaping (Pollution?) -> Void)
    {
        let stationIds = AppPreferences.PollutionId
        if stationIds == nil || stationIds?.count == 0
        {
            print("not fetching pollution for default")
            pollutionCallback(nil)
            return
        }
        else if stationIds![0] as! Int == 0
        {
    
            print("not fetching pollution for default")
            pollutionCallback(nil)
            return

        }
        print(stationIds)
        fetchPollution(index: 0, stationIds: stationIds as! [Int]?, pollutionCallback: pollutionCallback)
        
    }
    
    static func fetchPollution( index: Int, stationIds: [Int]?, pollutionCallback: @escaping (Pollution?) -> Void)
    {
        print("fetcing pollution for" + String(stationIds![index]))
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStr = dateFormatter.string(from: date as Date)
        
        let url = String(format: Constants.POLLUTION_URL, stationIds![index], dateStr)
        let request = NSURL(string: url)
        let urlRequest = NSURLRequest(url: request! as URL)
        var index = 0
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                
                if error != nil
                {
                    print(error)
                }
                else if(data != nil)
                {
                    let pollution = getPollutionFromJSON(data: data! as NSData)
                    if pollution == nil
                    {
                        index = index + 1
                        if stationIds!.count > index
                        {
                            fetchPollution(index: index, stationIds: stationIds, pollutionCallback: pollutionCallback)
                        }
                    }
                    
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
            pollutionDict = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy hh:mm a"
        
        let pollutionDate = dateFormatter.date(from: dateStr)
        
        let pollution: Pollution = Pollution(
            updatedTime: pollutionDict["date"] as! String,
            updatedLong: Int((pollutionDate?.timeIntervalSince1970)!),
            qualityIndex:  aqiDict["value"] as! Double,
            suggestion: "",
            pollutionColor: NSColor.black
            )
        
        return pollution
        
    }
    
}

