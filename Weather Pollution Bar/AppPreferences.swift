//
//  AppPreferences.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation
import Cocoa

class AppPreferences
{
    
    static var CityId:Int {
        get{
        
            return NSUserDefaults.standardUserDefaults().integerForKey(Defaults.CITY_ID)
        }
        set(value) {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: Defaults.CITY_ID)
        }
        
    }
    
    static var Units: String{
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Defaults.UNITS)!
        }
        set(value)
        {
            NSUserDefaults.standardUserDefaults().setValue(value, forKeyPath: Defaults.UNITS)
        }
    }
    
    static var ShowFutureWeather: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Defaults.SHOW_FUTURE_WEATHER)
        }
        set(value)
        {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: Defaults.SHOW_FUTURE_WEATHER)
        }
    }
    
    static var SyncInterval: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Defaults.SYNC_INTERVAL)
        }
        set(value)
    {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: Defaults.SYNC_INTERVAL)
        }
    }
}
