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
    
    @IBOutlet var weatherCityArrayController: NSArrayController!
    @IBOutlet weak var showFutureWeatherCheck: NSButton!
    
    var weatherCitiesArray: [WeatherCity] = []
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        unitCombo.addItemsWithObjectValues(Constants.UNITS)
        syncCombo.addItemsWithObjectValues(Constants.SYNC_INTERVAL)
        
       // unitCombo.selectItemAtIndex(0)
       // syncCombo.selectItemAtIndex(0)

        
        let cities = NSBundle.mainBundle().pathForResource("cities", ofType: "json")
        if let citiesFile = cities
        {
            let data = NSData.dataWithContentsOfMappedFile(citiesFile)
            
            do {
            
                let citiesArray = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
                
                for city: NSDictionary in citiesArray as! [NSDictionary]
                {
                    let weatherCity = getCity(city)
                   
                    weatherCitiesArray.insert(weatherCity, atIndex: weatherCitiesArray.count)
                 
                    
                }
                
                self.willChangeValueForKey("weatherCitiesArray")
                self.didChangeValueForKey("weatherCitiesArray")
                          }
            catch
            {
                print("Error occurred")
            }
            
            
        }
      
            self.showFutureWeatherCheck.objectValue = AppPreferences.ShowFutureWeather
//            self.cityCombo.objectValue = AppPreferences.
            //self.unitCombo.selectItemWithObjectValue("F")
        self.syncCombo.objectValue = AppPreferences.SyncInterval
        self.unitCombo.objectValue = AppPreferences.Units
        
        
        
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
    
    @IBAction func selectCity(sender: AnyObject) {
        //print((cityCombo.objectValueOfSelectedItem))
        //print(cityCombo.objectValue)
        //print(weatherCityArrayController.selectionIndex)
    }
    
    @IBAction func selectUnit(sender: AnyObject) {
        //print(unitCombo.objectValueOfSelectedItem)
        //print(unitCombo.objectValue)
        
        AppPreferences.Units = unitCombo.objectValueOfSelectedItem as! String
    }
    
    @IBAction func selectSyncInterval(sender: AnyObject) {
        //print(syncCombo.objectValueOfSelectedItem)
        //AppPreferences.SyncInterval = Constants.syncIntervalDict[syncCombo.objectValueOfSelectedItem! as! String]!
        
        AppPreferences.SyncInterval = syncCombo.objectValueOfSelectedItem as! Int
    }
   
    
    @IBAction func selectShowFutureWeather(sender: AnyObject) {
        //print(showFutureWeatherCheck.objectValue)
        AppPreferences.ShowFutureWeather = showFutureWeatherCheck.objectValue! as! Int
    }
    
    
}
