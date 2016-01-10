//
//  StatusMenuController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject
{
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var weatherMenuItem: NSMenuItem!
    @IBOutlet weak var pollutionMenuItem: NSMenuItem!
    
    var weatherView: WeatherView?
    var pollutionView: PollutionView?
    
    var settingsWindowController: SettingsWindowController?
    var aboutWindowController: AboutWindowController?
    
    let statusItem  = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: "statusIcon")
        icon?.size = NSSize.init(width: 18, height: 18)
        
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherView = WeatherView()
        pollutionView = PollutionView()
        
        weatherMenuItem.view = weatherView?.view
        pollutionMenuItem.view = pollutionView?.view
        
       weatherView?.statusMenuViewController = self
       pollutionView?.statusMenuViewController = self
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotification:", name: Constants.UPDATE_NOTIFICATION, object: nil)
        
        let defaultsDict = NSMutableDictionary()

        defaultsDict.setValue(1277333, forKey: Defaults.CITY_ID)
        defaultsDict.setValue(Constants.ICON_TYPE[1], forKey: Defaults.ICON_TYPE)
        defaultsDict.setValue(Constants.SYNC_INTERVAL[0], forKey: Defaults.SYNC_INTERVAL)
        defaultsDict.setValue(Constants.UNITS[0], forKey: Defaults.UNITS)
        defaultsDict.setValue(0, forKey: Defaults.POLLUTION_ID)
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsDict as! [String : AnyObject])

    }
    
    func updateNotification(notification: NSNotification)
    {
        
        update(weatherMenuItem)
    }
    
    func hideViews()
    {
        statusMenu.removeItemAtIndex(2)
        statusMenu.removeItemAtIndex(4)
    }
    
    func showWeather()
    {
        if weatherMenuItem.menu == nil
        {
            statusMenu.insertItem(weatherMenuItem, atIndex: 2)
        }
        
    }
    
    func showPollution()
    {
        if pollutionMenuItem.menu == nil
        {
            statusMenu.insertItem(pollutionMenuItem, atIndex: 4)
        }
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem)
    {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func update(sender: NSMenuItem)
    {
        weatherView?.updateWeather()
        pollutionView?.updatePollution()
        
    }
    
    @IBAction func settingsClicked(sender: NSMenuItem)
    {
        self.settingsWindowController = SettingsWindowController()
        settingsWindowController?.showWindow(self)
        
    }
    
    
    @IBAction func aboutClicked(sender: NSMenuItem)
    {
        self.aboutWindowController = AboutWindowController()
        aboutWindowController?.showWindow(self)
        
    }
    
    
}
