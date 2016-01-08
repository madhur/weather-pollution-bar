//
//  PollutionView.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 06 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class PollutionView: NSViewController {
    
    //static var pollution: Pollution?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        PollutionFetcher.fetch(pollutionCallback)
    }
    
    override var nibName : String{
        return "PollutionView"
    }
    
    
    var pollutionCallback =
    {
        (pollution: Pollution?) in
        
        print(pollution)
    }
    
}
