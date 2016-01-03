//
//  SettingsWindowController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController {

    @IBOutlet weak var cityCombo: NSComboBox!
    
    @IBOutlet weak var unitCombo: NSComboBox!
    
    @IBOutlet weak var syncCombo: NSComboBox!
    
    @IBOutlet weak var showFutureWeatherCheck: NSButton!
    
    var weatherCitiesArray: [WeatherCity] = []
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        let cities = NSBundle.mainBundle().pathForResource("cities", ofType: "json")
        if let citiesFile = cities
        {
            let data = NSData.dataWithContentsOfMappedFile(citiesFile)
            
            do {
            
                let citiesArray = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
                
                for city: NSDictionary in citiesArray as! [NSDictionary]
                {
                    let weatherCity = getCity(city)
                    weatherCitiesArray.append(weatherCity)
                }
                
                //print(weatherCitiesArray)
               // print(citiesArray)
            }
            catch
            {
                print("Error occurred")
            }
            
            
        }
        
        print(weatherCitiesArray)
        
    }
    
    override var windowNibName: String
    {
        return "SettingsWindowController"
    }
    
    @IBAction func settingsClose(sender: NSButton)
    {
        self.close()
    }
    
    func getCity(data: NSDictionary) -> WeatherCity
    {
        let coord = data["coord"] as! NSDictionary
        
        let city: WeatherCity = WeatherCity()
        city.id = data["_id"] as? Int
        city.name = data["name"] as? String
        city.countryCode = data["country"] as? String
        city.latitude = coord["lat"] as? Double
        city.longitude = coord["lon"] as? Double
        
        return city
        
    }
    
}
