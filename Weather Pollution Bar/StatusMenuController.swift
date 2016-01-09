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
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherView = WeatherView()
        pollutionView = PollutionView()
        
        weatherMenuItem.view = weatherView?.view
        pollutionMenuItem.view = pollutionView?.view
        
       weatherView?.statusMenuViewController = self
       pollutionView?.statusMenuViewController = self
        
  
        
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
