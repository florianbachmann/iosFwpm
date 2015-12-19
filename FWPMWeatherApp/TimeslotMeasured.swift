//
//  TimeslotMeasured.swift
//  FWPMWeatherApp
//
//  Created by student on 18.12.15.
//  Copyright © 2015 de.fhws.k28316. All rights reserved.
//

import Foundation

class TimeslotMeasured {
    var dateAndTime:NSDate
    var mainTempInCelsius:Float
    var mainHumidity:Int
    var weatherMainly:String //Könnte man auch als Enum machen
    var weatherDescription:String //Könnte man auch als Enum machen
    var weatherIcon:String
    var cloudiness:Int
    var windSpeed:Float
    var windDegree:Float
    //var windDirection --> ENUM, welches die Degree bekommt und dann errechnet, welche Himmelsrichtung gemeint ist.
    var rainVolume:Float
    // var snowVolume:Double --> GLaub das gibts nicht.
    
    init(dateAndTimeUnix:Int, mainTemp:Float, mainHumidity: Int, weatherMainly:String, weatherDescription:String, weatherIcon:String, cloudiness:Int, windSpeed:Float, windDegree:Float, rainVolume:Float) {
        self.dateAndTime = NSDate(timeIntervalSince1970: Double(dateAndTimeUnix)) //man bekommt die "dt"-Zeit aus dem JSON in Int und es wird in NSDate geparst.
        let format = NSNumberFormatter()
        format.numberStyle = NSNumberFormatterStyle.DecimalStyle
        format.maximumFractionDigits = 1
        let tempInCelsius = mainTemp - 273.15
        self.mainTempInCelsius = Float(format.stringFromNumber(tempInCelsius)!)!
        
        self.mainHumidity = mainHumidity
        self.weatherMainly = weatherMainly
        self.weatherDescription = weatherDescription
        self.weatherIcon = weatherIcon
        self.cloudiness = cloudiness
        self.windSpeed = windSpeed
        self.windDegree = windDegree
        self.rainVolume = rainVolume
        
    }
    
    func description() -> String {
        return "Date: \(self.dateAndTime.description), Temp: \(self.temperatureDescription()), Humidity: \(self.mainHumidity), Weather: \(self.weatherDescription)"
    }
    
    func temperatureDescription() -> String {
        return "\(self.mainTempInCelsius) C°"
    }
}
