//
//  SettingsWindowController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSComboBoxDataSource, NSComboBoxDelegate {

    @IBOutlet weak var cityCombo: NSComboBox!
    
    @IBOutlet weak var unitCombo: NSComboBox!
    
    @IBOutlet weak var syncCombo: NSComboBox!
    
    @IBOutlet weak var iconCombo: NSComboBox!
    var weatherCitiesArray: [WeatherCity] = []
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        unitCombo.addItemsWithObjectValues(Constants.UNITS)
        syncCombo.addItemsWithObjectValues(Constants.SYNC_INTERVAL)
        iconCombo.addItemsWithObjectValues(Constants.ICON_TYPE)
        
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
                
            }
            catch
            {
                print("Error occurred")
            }
            
            
        }
      
        self.syncCombo.objectValue = AppPreferences.SyncInterval
        self.unitCombo.objectValue = AppPreferences.Units
        self.iconCombo.objectValue = AppPreferences.IconType
        let cityIndex = getCityIndexById(AppPreferences.CityId)
        
        if let cityIndexVal = cityIndex
        {
            //self.cityCombo.selectItemAtIndex(cityIndexVal.keys.first!)
            self.cityCombo.stringValue = (cityIndexVal.values.first?.name!)!
        }
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
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
        //if(cityCombo.indexOfSelectedItem == -1)
        //{
            let typedCity = cityCombo.stringValue
            let selectedIndex = getCityIndex(typedCity)
            if selectedIndex != nil
            {
                cityCombo.selectItemAtIndex((selectedIndex?.keys.first!)!)
                print("selected" + String(selectedIndex))
                AppPreferences.CityId = (selectedIndex?.values.first?.id)!
                
            }
        //}
    }
    
    func getCityIndex(typedCity : String) -> [Int: WeatherCity]?
    {
        
        for (index, city) in weatherCitiesArray.enumerate()
        {
            if(city.name == typedCity)
            {
                return [index: city]
            }
        }
        
        return nil
    }
    
    func getCityIndexById(cityId: Int) -> [Int: WeatherCity]?
    {
        for (index, city) in weatherCitiesArray.enumerate()
        {
            if(city.id == cityId)
            {
                return [index: city]
            }
        }
        
        return nil
    }
    
    @IBAction func selectUnit(sender: AnyObject) {
        AppPreferences.Units = unitCombo.objectValueOfSelectedItem as! String
    }
    
    @IBAction func selectSyncInterval(sender: AnyObject) {
        AppPreferences.SyncInterval = syncCombo.objectValueOfSelectedItem as! Int
    }
    
    @IBAction func selectIcon(sender: NSComboBox) {
        AppPreferences.IconType = iconCombo.objectValueOfSelectedItem as! String
    }
    
    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return weatherCitiesArray.count
    }
    
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        
        if index == -1
        {
            print("recieved -1")
            return weatherCitiesArray[0]
        }
        
        return weatherCitiesArray[index].name!
        
    }
    
    func comboBoxSelectionDidChange(notification: NSNotification) {
        
        print(weatherCitiesArray[cityCombo.indexOfSelectedItem].name!)
        AppPreferences.CityId = weatherCitiesArray[cityCombo.indexOfSelectedItem].id!
        
    }
    
//    func comboBox(aComboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
//       // print(string)
//        let index =  getCityIndex(string)
//        if let indexVal = index
//        {
//            return indexVal.keys.first!
//        }
//        
//        print("returning zero for" + string)
//        return 0
//        
//    }
    
}
