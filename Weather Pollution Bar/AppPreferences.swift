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
        
            return UserDefaults.standard.integer(forKey: Defaults.CITY_ID)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Defaults.CITY_ID)
           // update()
        }
        
    }
    
    static var PollutionId: [AnyObject]? {
        get{
        
            return UserDefaults.standard.array(forKey: Defaults.POLLUTION_ID) as [AnyObject]?
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Defaults.POLLUTION_ID)
        }
        
    }
    
    static var Units: String?{
        get {
            return UserDefaults.standard.string(forKey: Defaults.UNITS)
        }
        set(value)
        {
            UserDefaults.standard.setValue(value, forKeyPath: Defaults.UNITS)
            update()
        }
    }
    
    
    static var SyncInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: Defaults.SYNC_INTERVAL)
        }
        set(value)
        {
            UserDefaults.standard.set(value, forKey: Defaults.SYNC_INTERVAL)
        }
    }
    
    static var IconType: String {
        get {
            return UserDefaults.standard.string(forKey: Defaults.ICON_TYPE)!
        }
        set(value)
        {
            UserDefaults.standard.setValue(value, forKey: Defaults.ICON_TYPE)
            update()
        }
    }

    
    
    static func update()
    {
       // let updateNotif = NSNotification()
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.UPDATE_NOTIFICATION), object: nil)
    }
}
