//
//  PollutionColorView.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 09 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

//import Foundation
import Cocoa

class PollutionColorView: NSView
{
    var drawText: String = ""
    
    let rectHeight:Int = 50
    
    //let rectWidth:Int = 40
    
    static let alpha = CGFloat.init(integerLiteral: 1)
    
    let colors = [
        
        NSColor.init(red: 0, green: 141 / 255.0, blue: 61 / 255.0, alpha: alpha),
        NSColor.init(red: 117 / 255.0, green: 166 / 255.0, blue: 64 / 255.0, alpha: alpha),
        NSColor.init(red: 204 / 255.0, green: 204 / 255.0, blue: 0, alpha: alpha),
        NSColor.init(red: 204 / 255.0, green: 122 / 255.0, blue: 0, alpha: alpha),
        NSColor.init(red: 204 / 255.0, green: 0, blue: 0, alpha: alpha),
        NSColor.init(red: 154 / 255.0, green: 0, blue: 0, alpha: alpha)
    
    ]
    
    
    override func drawRect(dirtyRect: NSRect) {
        
        let rectWidth = Int(bounds.width.native / 6)
        
        for index in 0...5
        {
            colors[index].set()
            let rect = NSRect.init(origin: CGPoint.init(x: index*rectWidth, y: 0), size: CGSize.init(width: rectWidth, height: rectHeight))
            NSBezierPath.fillRect(rect)
        }
        
    }
    
  
    
    
}
