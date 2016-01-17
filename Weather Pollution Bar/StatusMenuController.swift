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
    var timer: NSTimer?
    
    var settingsWindowController: SettingsWindowController?
    var aboutWindowController: AboutWindowController?
    
    let statusItem  = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        var defaultsDict = [String: AnyObject]()
        
        
        defaultsDict[Defaults.CITY_ID]=1277333
        defaultsDict[Defaults.ICON_TYPE] = Constants.ICON_TYPE[1]
        defaultsDict[Defaults.UNITS] = Constants.UNITS[0]
        defaultsDict[Defaults.SYNC_INTERVAL] = Constants.SYNC_INTERVAL[0]
        defaultsDict[Defaults.POLLUTION_ID] = [0]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsDict)

        
        let icon = NSImage(named: "statusIcon")
        icon?.size = NSSize.init(width: 18, height: 18)
        icon?.cacheMode = NSImageCacheMode.Never
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
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(Double(Constants.SYNC_INTERVAL[0]*60), target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        //let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        self.timer = timer
        
        print(statusMenu.itemArray.count)
        
        

    }
    
    func updateNotification(notification: NSNotification)
    {
        
        update(weatherMenuItem)
        
    }
    
    func update()
    {
        update(weatherMenuItem)
    }
    

    func hidePollution()
    {
        if statusMenu.itemArray.count >= 8
        {
            statusMenu.removeItemAtIndex(4)
        }

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
        
        showNotification()
        
    }
    
    @IBAction func settingsClicked(sender: NSMenuItem)
    {
        self.settingsWindowController = SettingsWindowController()
        settingsWindowController?.showWindow(self)
        settingsWindowController?.statusMenuController = self
    }
    
    
    @IBAction func aboutClicked(sender: NSMenuItem)
    {
        self.aboutWindowController = AboutWindowController()
        aboutWindowController?.showWindow(self)
        
    }
    
    
    func showNotification()
    {
        #if DEBUG
            let notification  = NSUserNotification.init()
            notification.title = "Updating Weather"
            notification.soundName = NSUserNotificationDefaultSoundName
            let center = NSUserNotificationCenter.defaultUserNotificationCenter()
            center.deliverNotification(notification)
        #endif
        

    }
    
    
}
