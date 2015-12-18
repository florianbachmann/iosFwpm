//
//  Properties.swift
//  FWPMWeatherApp
//
//  Created by student on 13.12.15.
//  Copyright © 2015 de.fhws.k28316. All rights reserved.
//

import Foundation

/*
JSON: Aufbau und Felder die wir brauchen:
1 - City
2 - ForeCastObject
    - Time of data forecasted. UNIX Time in UTC
    - main-Dict:
        - temp (in fahrenheit)
        - humidity (Humidity, %)
    - weather-Array
        - main (z.B. "Rain" --> Group of weather parameters (Rain, Snow, Extreme etc.))
        - description (z.B: light rain) --> (Group of weather parameters (Rain, Snow, Extreme etc.))
        - icon: Weather icon id (z.b. 10n)
    - clouds-Dict
        - all: (Cloudiness, %)
    - wind-Dict
        - speed (z.B. 5.92) --> Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
        - deg (z.B. 211) --> Wind direction, degrees (meteorological)
    - rain-Dict
        - 3h: z.B. 0.61 --> Rain volume for last 3 hours, mm
    - snow-Dict
        - Wurde bei uns nicht geholt..
*/


/**
Objektmodell: Eine Stadt hat eine anzahl von Wetterdaten. Gemessen alle drei Stunden. D.h. 8 Wetter-vorhersagen.
**/

class GlobalData {
    var city:City //eine Stadt für die die App die Daten hält
    //var days:[Day] //Alle Tage der Vorhersage
    var daysAndWeather = Dictionary<String, Array<TimeslotForecast>>()
    
    init(city:City) {
        self.city = city
    }
    
    func printGlobalData() {
        print("Printing Global Data..")
        print("For: \(city.name) in \(city.country)")
        for key in daysAndWeather.keys {
            print("Forecast for \(key)")
            for w in daysAndWeather[key]! {
                print(w.description())
            }
            
        }
    }
}



struct City {
    var name:String
    var country:String
}

class TimeslotForecast {
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
        self.mainTempInCelsius = Float(mainTemp - 273.15).roundToPlaces(1) //Temp kommt in Kelvin rein. Muss umgewandelt werden
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

extension Float {
    func roundToPlaces(places: Int) -> Float {
        let divisor = pow(10.0, Double(places))
        return Float(round(Double(self) * divisor) / divisor)
    }
}

