//
//  PollutionView.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 06 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class PollutionView: NSViewController {
    
    @IBOutlet weak var advisoryLabel: NSTextField!
    @IBOutlet weak var pollutionColorView: PollutionColorView!
    var statusMenuViewController: StatusMenuController?
    
    @IBOutlet weak var updatedLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        updatePollution()
        
    }
    
    override var nibName : String{
        return "PollutionView"
    }
    
    func updatePollution()
    {
        PollutionFetcher.fetch(pollutionCallback)
    }
    
    
    var pollutionCallback: (pollution: Pollution?) -> Void { return
        {
            (pollution: Pollution?) in
            
            if pollution == nil
            {
                self.statusMenuViewController?.hidePollution()
                return
                
            }
            
            self.statusMenuViewController?.showPollution()
            
            switch((pollution?.qualityIndex)!)
            {
               
                case 0...50:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[0]
                case 51...100:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[1]
                case 101...200:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[2]
                case 201...300:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[3]
                case 301...400:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[4]
                case 401...500:
                    self.advisoryLabel.stringValue = Constants.ADVISORY[5]
                
                default: break

            }
            
            self.pollutionColorView.setPollutionValue((pollution?.qualityIndex)!)
            
           // self.updatedLabel.stringValue = getReadableTime((pollution?.updatedLong)!)
            
            self.statusMenuViewController?.pollutionMenuItem.toolTip = getReadableTime((pollution?.updatedLong)!)
            
            //print(pollution)
        }
    }
    
}
