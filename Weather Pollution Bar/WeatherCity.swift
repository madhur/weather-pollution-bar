//
//  WeatherCity.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 04 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//



import Foundation

class WeatherCity: NSObject
{
    var id: Int?
    var name: String?
    var countryCode: String?
    var latitude: Double?
    var longitude: Double?
    
    override init()
    {
        
    }
}

class PollutionCity: NSObject
{
    var id: Int?
    var name: String?
    var latitude: Double?
    var longitude: Double?
}