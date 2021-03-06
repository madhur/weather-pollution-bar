//
//  SettingsWindowController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa
import CoreLocation

class SettingsWindowController: NSWindowController, NSComboBoxDataSource, NSComboBoxDelegate {
    
    @IBOutlet weak var cityCombo: NSComboBox!
    
    @IBOutlet weak var unitCombo: NSComboBox!
    
    @IBOutlet weak var syncCombo: NSComboBox!
    
    @IBOutlet weak var iconCombo: NSComboBox!
    var weatherCitiesArray: [WeatherCity] = []
    
    var statusMenuController: StatusMenuController!
    
    @IBOutlet weak var pollutionLabel: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        unitCombo.addItemsWithObjectValues(Constants.UNITS)
        syncCombo.addItemsWithObjectValues(Constants.SYNC_INTERVAL)
        iconCombo.addItemsWithObjectValues(Constants.ICON_TYPE)
        
        NSOperationQueue().addOperationWithBlock({
            
            let cities = NSBundle.mainBundle().pathForResource("cities", ofType: "json")
            if let citiesFile = cities
            {
                let data = NSData.dataWithContentsOfMappedFile(citiesFile)
                
                do {
                    
                    let citiesArray = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
                    
                    for city: NSDictionary in citiesArray as! [NSDictionary]
                    {
                        let weatherCity = self.getCity(city)
                        
                        self.weatherCitiesArray.insert(weatherCity, atIndex: self.weatherCitiesArray.count)
                        
                    }
                    
                }
                catch
                {
                    print("Error occurred")
                }
                
            }
            
            let cityIndex = self.getCityIndexById(AppPreferences.CityId)
            
            if let cityIndexVal = cityIndex
            {
                
                self.cityCombo.stringValue = (cityIndexVal.values.first?.name!)!
            }

        
        })
        
        self.syncCombo.objectValue = AppPreferences.SyncInterval
        self.unitCombo.objectValue = AppPreferences.Units
        self.iconCombo.objectValue = AppPreferences.IconType
        
        if AppPreferences.PollutionId![0] as! Int != 0
        {
            pollutionLabel.stringValue = "Nearest pollution center is: " + (getPollutionById(AppPreferences.PollutionId![0] as! Int)?.name)!
        }
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
    
    func getPollutionCity(data: NSDictionary) -> PollutionCity
    {
        
        let city: PollutionCity = PollutionCity()
        city.id = data["id"] as? Int
        city.name = data["name"] as? String
        city.latitude = Double((data["lat"] as? String)!)
        city.longitude = Double((data["long"] as? String)!)
        
        return city
    }
    
    @IBAction func selectCity(sender: AnyObject) {
       
        let typedCity = cityCombo.stringValue
        let selectedIndex = getCityIndex(typedCity)
        if selectedIndex != nil
        {
            cityCombo.selectItemAtIndex((selectedIndex?.keys.first!)!)
            print("selected" + String(selectedIndex))
            AppPreferences.CityId = (selectedIndex?.values.first?.id)!
            selectPollution((selectedIndex?.values.first)!)
            
            AppPreferences.update()
        }
        
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
        
        statusMenuController.timer?.invalidate()
        statusMenuController.timer = nil
        
        print("setting refresh interval to" + String(AppPreferences.SyncInterval))
        
        statusMenuController.timer = NSTimer.scheduledTimerWithTimeInterval(Double(AppPreferences.SyncInterval*60), target: statusMenuController, selector: Selector("update"), userInfo: nil, repeats: true)
        
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
        
//        print(weatherCitiesArray[cityCombo.indexOfSelectedItem].name!)
//        let cityId = weatherCitiesArray[cityCombo.indexOfSelectedItem].id!
//        AppPreferences.CityId = cityId
//        
//        let CityIdDict = getCityIndexById(cityId)
//        
//        selectPollution((CityIdDict?.values.first)!)
        
    }
    
    func selectPollution(selectedWeathercity: WeatherCity)
    {
        
        let pollutionData = getPollutionById(selectedWeathercity.latitude!, longitude: selectedWeathercity.longitude!)
        
        let pollutionIds = pollutionData.pollutionIds
        
        if pollutionIds.count > 0
        {
            AppPreferences.PollutionId = pollutionIds
            print("setting nearest pollution id" + String(pollutionIds))
            pollutionLabel.stringValue = "Nearest pollution center is: " + String(pollutionData.pollutionCitiesArray[0].name!)
        }
        else
        {
            print("No nearest pollution center found")
            AppPreferences.PollutionId = [0]
            pollutionLabel.stringValue = "No nearest pollution center found"
        }
        
    }
    
    func getPollutionById(latitude: Double, longitude: Double) -> PollutionData
    {
        var pollutionCitiesArray: [PollutionCity] = []

        let weatherLocation: CLLocation = CLLocation(
            latitude: CLLocationDegrees.abs(latitude),
            longitude: CLLocationDegrees.abs(longitude))
        
        var pollutionIds : [Int]? = []
        
        let pollutionCities = NSBundle.mainBundle().pathForResource("pollution_cities", ofType: "json")
        if let pollutionFile = pollutionCities
        {
            let data = NSData.dataWithContentsOfMappedFile(pollutionFile)
            
            do {
                
                let citiesArray = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
                
                let minDistance: CLLocationDistance = 30000
                
                
                for city: NSDictionary in citiesArray as! [NSDictionary]
                {
                    let pollutionCity = getPollutionCity(city)
                    
                    let pollutionLocation: CLLocation = CLLocation(
                        latitude: CLLocationDegrees.abs(pollutionCity.latitude!),
                        longitude: CLLocationDegrees.abs(pollutionCity.longitude!))
                    
                    
                    let distance = weatherLocation.distanceFromLocation(pollutionLocation)
                    
                    if distance < minDistance
                    {
                        
                        let nearestCenterId = pollutionCity.id
                        pollutionIds?.append(nearestCenterId!)
                        pollutionCitiesArray.append(pollutionCity)
                        
                    }
                    
                }
                
            }
            catch
            {
                print("Error occurred")
            }
        }

        return PollutionData(pollutionCitiesArray: pollutionCitiesArray, pollutionIds: pollutionIds!)
        
    }
    
    func getPollutionById(pollutionId: Int) -> PollutionCity?
    {
        
        let pollutionCities = NSBundle.mainBundle().pathForResource("pollution_cities", ofType: "json")
        if let pollutionFile = pollutionCities
        {
            let data = NSData.dataWithContentsOfMappedFile(pollutionFile)
            
            do {
                
                let citiesArray = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
                
                for city: NSDictionary in citiesArray as! [NSDictionary]
                {
                    let pollutionCity = getPollutionCity(city)
                    
                    if pollutionCity.id == pollutionId
                    {
                        return pollutionCity
                    }
                }
                
            }
            catch
            {
                print("Error occurred")
            }
        }
        
        return nil
        
    }
    
    struct PollutionData
    {
        var pollutionCitiesArray: [PollutionCity]
        var pollutionIds: [Int]
        
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
