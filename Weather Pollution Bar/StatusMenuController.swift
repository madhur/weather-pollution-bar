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
    var timer: Timer?
    
    var settingsWindowController: SettingsWindowController?
    var aboutWindowController: AboutWindowController?
    
    let statusItem  = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        
        var defaultsDict = [String: AnyObject]()
        
        
        defaultsDict[Defaults.CITY_ID]=1277333 as AnyObject
        defaultsDict[Defaults.ICON_TYPE] = Constants.ICON_TYPE[1] as AnyObject
        defaultsDict[Defaults.UNITS] = Constants.UNITS[0] as AnyObject
        defaultsDict[Defaults.SYNC_INTERVAL] = Constants.SYNC_INTERVAL[0] as AnyObject
        defaultsDict[Defaults.POLLUTION_ID] = [0] as AnyObject
        
        UserDefaults.standard.register(defaults: defaultsDict)

        
        let icon = NSImage(named: "statusIcon")
        icon?.size = NSSize.init(width: 18, height: 18)
        icon?.cacheMode = NSImage.CacheMode.never
        icon?.isTemplate = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherView = WeatherView()
        pollutionView = PollutionView()
        
        weatherMenuItem.view = weatherView?.view
        pollutionMenuItem.view = pollutionView?.view
        
       weatherView?.statusMenuViewController = self
       pollutionView?.statusMenuViewController = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatusMenuController.updateNotification), name: NSNotification.Name(rawValue: Constants.UPDATE_NOTIFICATION), object: nil)
        
        
        let timer = Timer.scheduledTimer(timeInterval: Double(Constants.SYNC_INTERVAL[0]*60), target: self, selector: #selector(StatusMenuController.update2), userInfo: nil, repeats: true)
        
        //let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        self.timer = timer
        
        print(statusMenu.items.count)
        
        

    }
    
    @objc func updateNotification(notification: NSNotification)
    {
        
        update(sender: weatherMenuItem)
        
    }
    
    @objc func update2()
    {
        update(sender: weatherMenuItem)
    }
    

    func hidePollution()
    {
        if statusMenu.items.count >= 8
        {
            statusMenu.removeItem(at: 4)
        }

    }
    func showWeather()
    {
        if weatherMenuItem.menu == nil
        {
            statusMenu.insertItem(weatherMenuItem, at: 2)
        }
        
    }
    
    func showPollution()
    {
        if pollutionMenuItem.menu == nil
        {
            statusMenu.insertItem(pollutionMenuItem, at: 4)
        }
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem)
    {
        NSApplication.shared.terminate(self)
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
        let center = NSUserNotificationCenter.default
        center.deliver(notification)
        #endif
        

    }
    
    
}
