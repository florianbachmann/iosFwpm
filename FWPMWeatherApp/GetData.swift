//
//  GetData.swift
//  FWPMWeatherApp
//
//  Created by student on 12.12.15.
//  Copyright © 2015 de.fhws.k28316. All rights reserved.
//

import Foundation
import SwiftyJSON


class GetData {
    
    var cityName:String
    var jsonData:NSData
    var gData:GlobalData?
    
    init(cityName:String) {
        self.cityName = cityName
        self.jsonData = NSData()
        putDataInDict()
    }
    
    func buildStringForDailyForecast() -> NSURL {
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(self.cityName),uk&appid=2de143494c0b295cca9337e1e96b00e0"
        return NSURL(string: url)!
    }
    
    func buildStringForWeeklyForecast() -> NSURL {
        let url = "http://api.openweathermap.org/data/2.5/forecast?q=\(self.cityName),uk&mode=json&appid=2de143494c0b295cca9337e1e96b00e0"
        return NSURL(string: url)!
    }
    
    func putDataInDict() {
        let request = NSURLRequest(URL: buildStringForWeeklyForecast()) //holt sich die URL von der Methode. Der rest ist kopierter Code von UebungNSURLSwift
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            guard let data = data else {
                return
            }
            self.jsonData = data
            print("got data")
            self.parseJson(self.jsonData)
        }).resume()
    }
    
    //JSON Data in Datenmodell parsen
    func parseJson(data: NSData) {
        let json = JSON(data: self.jsonData)
        
        let cty = City(name: json["city"]["name"].stringValue, country: json["city"]["country"].stringValue)
        gData = GlobalData(city: cty)
        var timeslotForecasts = [TimeslotForecast]()
        //Jeden für jeden Datenslot im JSON einen Datenslot im Datenmodell erstellen
        for (_,subJson) in json["list"] {
            let dt  = subJson["dt"].intValue
            let temp        = subJson["main"]["temp"].floatValue
            let humidity    = subJson["main"]["humidity"].intValue
            let weatherMainly   = subJson["weather"][0]["main"].stringValue
            let weatherDescr    = subJson["weather"][0]["description"].stringValue
            let weatherIcon     = subJson["weather"][0]["icon"].stringValue
            let cloudy      = subJson["clouds"]["all"].intValue
            let windSpeed   = subJson["wind"]["speed"].floatValue
            let windDegree  = subJson["wind"]["deg"].floatValue
            let rain = subJson["rain"]["3h"].floatValue
            //Create a new TimeslotForecast-Object and put in Array.
            timeslotForecasts.append(TimeslotForecast(dateAndTimeUnix: dt, mainTemp: temp, mainHumidity: humidity, weatherMainly: weatherMainly, weatherDescription: weatherDescr, weatherIcon: weatherIcon, cloudiness: cloudy, windSpeed: windSpeed, windDegree: windDegree, rainVolume: rain))
        }
       
        var tempDate:NSDate = self.shortenDate(timeslotForecasts[0].dateAndTime)
        
        //Kalkuliertes Datum.. Der fünfte Tag nach dem ersten Messtag --> Wird gebraucht um zu prüfen ob eine Messzeit länger als 4 Tage weg ist
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.day = 5
        let latestDate:NSDate = calendar.dateByAddingComponents(dateComponent, toDate: tempDate, options:NSCalendarOptions())!
        //print("Datecheck: first day: \(tempDate.description), last Day: \(latestDate.description)")
        
        var i = 0
        //timeslots auf Tage aufteilen und in Objektmodell speichern.
        for ts in timeslotForecasts {
            //Tag von der Uhrzeit abschneiden, um vergleichen zu können
            let newDate:NSDate = self.shortenDate(ts.dateAndTime)
            
            if newDate.compare(latestDate) != NSComparisonResult.OrderedSame {
                switch newDate.compare(tempDate) {
                case NSComparisonResult.OrderedSame:
                    //print("----same date----")
                    if gData!.daysAndWeather.keys.contains(newDate.description) {
                        gData!.daysAndWeather["\(newDate.description)"]!.append(ts)
                        print("new element - \(ts.description()) to \(newDate.description)")
                    } else {
                        gData!.daysAndWeather["\(newDate.description)"] = Array<TimeslotForecast>()
                        gData!.daysAndWeather["\(newDate.description)"]!.append(ts)
                        print("new key - \(ts.description()) to \(newDate.description)")
                    }
                    
                    
                    break
                case NSComparisonResult.OrderedDescending:
                    //print("----new date----")
                    tempDate = newDate
                    if gData!.daysAndWeather.keys.contains(newDate.description) {
                        gData!.daysAndWeather["\(newDate.description)"]!.append(ts)
                        print("new element - \(ts.description()) to \(newDate.description)")
                    } else {
                        gData!.daysAndWeather["\(newDate.description)"] = Array<TimeslotForecast>()
                        gData!.daysAndWeather["\(newDate.description)"]!.append(ts)
                        print("new key - \(ts.description()) to \(newDate.description)")
                    }
                    break
                default:
                    break
                }
            } else {
                print("Date \(newDate.description) is later than \(latestDate.description) and will not be saved.")
            }
          
        }
        gData?.printGlobalData()
        
    
    }
    
    func shortenDate(date:NSDate) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let newDate:NSDate = dateFormatter.dateFromString(dateFormatter.stringFromDate(date))!
        //print("formatted Date \(date.description) to \(newDate.description)")
        
        //Workaround: Ohne das Addieren von einem Tag konvertiert die Methode das datum zwar richtig, aber einen Tag zu früh..
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.day = 1
        let latestDate:NSDate = calendar.dateByAddingComponents(dateComponent, toDate: newDate, options:NSCalendarOptions())!
        //print("formatted Date \(date.description) to \(latestDate.description)")
        
        return latestDate
    }
    
}

