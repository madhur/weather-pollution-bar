//
//  Weather.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 06 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Foundation

struct Weather
{
    var updatedTime: String
    var updatedLong: Int
    var todayWeather: TodayWeather?
    var location: String
    
}

struct FutureWeather
{
    var title: String
    var temperature: Temperature
    var description: String
    var temperatureIcon: String
    var updatedLong: Int
}

struct TodayWeather
{
    var title: String
    var temperature: Temperature
    var description: String
    var temperatureIcon: String
}

struct Temperature
{
    var min: Double
    var max: Double
    var current: Double
    var degree : String
}