//
//  AboutWindowController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    @IBOutlet weak var homeButton: NSButton!
    
    @IBOutlet weak var twitterButton: NSButton!
    
    @IBOutlet weak var gitButton: NSButton!
    
    
    override var windowNibName: String
    {
            return "AboutWindowController"
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionText.stringValue = String(format: Constants.VERSION,  version as! NSString)
       
       // progImage.image = NSImage(named: "statusIcon")
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

    }
    
    @IBAction func openHomepage(sender: AnyObject) {
        
        let  workspace = NSWorkspace()
        
        if sender as! NSObject == homeButton
        {
            workspace.open(NSURL(string: Constants.HOME_URL)! as URL)
        }
        else if sender as! NSObject == twitterButton
        {
            workspace.open(NSURL(string: Constants.TWITTER_URL)! as URL)
        }
        else if sender as! NSObject == gitButton
        {
            workspace.open(NSURL(string: Constants.GIT_URL)! as URL)
        }
        
    }
    
    @IBOutlet weak var versionText: NSTextField!
    @IBOutlet weak var progImage: NSImageView!
}
