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
    var aqi: Double?
    
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
    
    var rectArray: [NSRect] = []
    
    override func drawRect(dirtyRect: NSRect) {
        
        let rectWidth = Int(bounds.width.native / 6)
        
        
        
        for index in 0...5
        {
            colors[index].set()
            let rect = NSRect.init(origin: CGPoint.init(x: index*rectWidth, y: 0), size: CGSize.init(width: rectWidth, height: rectHeight))
            NSBezierPath.fillRect(rect)
            rectArray.append(rect)
        }
        
        if let aqiValue = aqi
        {
            NSColor.whiteColor().set()
            
            let aqiText = NSMutableAttributedString(string: Int(aqiValue).description)
            aqiText.addAttribute(NSForegroundColorAttributeName, value: NSColor.whiteColor(), range: NSRange.init(location: 0, length: aqiText.length))
            aqiText.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(20), range: NSRange.init(location: 0, length: aqiText.length))
            
            let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            paraStyle.alignment = .Center
            aqiText.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange.init(location: 0, length: aqiText.length))
            
            
            switch(aqiValue)
            {
            case 0...50:
               
                aqiText.drawAtPoint(NSPoint.init(x: 10, y: 0))
            
            case 51...100:
                
                aqiText.drawAtPoint(NSPoint.init(x: 10 + rectWidth, y: 0))
            case 101...200:
                
                aqiText.drawAtPoint(NSPoint.init(x: 5 + rectWidth*2, y: 0))
            case 201...300:
            
                aqiText.drawAtPoint(NSPoint.init(x: 5 + rectWidth*3, y: 0))
            case 301...400:
  
                aqiText.drawAtPoint(NSPoint.init(x: 5 + rectWidth*4, y: 0))
            case 401...500:

                aqiText.drawAtPoint(NSPoint.init(x: 5 + rectWidth*5, y: 0))
                
            default: break
                
            }
        }
        
    }
    
    func setPollutionValue(aqi: Double)
    {
        self.aqi = aqi
        needsDisplay = true
    }
    
    
  
    
    
}
