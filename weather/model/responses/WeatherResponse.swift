//
//  weatherStruct.swift
//  weather
//
//  Created by Nipuna C on 27/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable{
    let lat: Double
    let lon: Double
    let timezone: String
    let daily: [DailyWeather]
}

struct DailyWeather: Codable {
    let dt : Int
    let sunrise: Int
    let sunset : Int
    let clouds : Int
    let pop : Double
    let uvi : Double
    let weather: [WeatherStruct]
}

struct WeatherStruct: Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}

