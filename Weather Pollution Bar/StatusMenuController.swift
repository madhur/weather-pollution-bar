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
    
    var settingsWindowController: SettingsWindowController?
    var aboutWindowController: AboutWindowController?
    
    let statusItem  = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem)
    {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func update(sender: NSMenuItem)
    {
        
        
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
