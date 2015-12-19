//
//  WeeklyForecastViewController.swift
//  FWPMWeatherApp
//
//  Created by student on 12.12.15.
//  Copyright © 2015 de.fhws.k28316. All rights reserved.
//

/*
    Nicht vergessen bei UITableView:
        - von Table View auf StudentenViewController Delegates und DataSource ziehen!
        - Methoden überschreiben
        - usw..
*/

import UIKit

class WeeklyForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
/*
    Delegate: Controls how the table is displayed
    DataSource: Provides, what is displayed in the cells
*/
    
    @IBOutlet weak var tableView: UITableView!
    var forecastObj:ForecastObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("weeklyForecast Controller loaded")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
                print("sumberOfsectionsInTableview")
        return 1

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        if let frcast = ForecastObject.instance {
            self.forecastObj = frcast
            return frcast.daysArray.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("gettin cell..")
        let cell = tableView.dequeueReusableCellWithIdentifier("WeeklyForecastDayCell") as! WeeklyForecastDayCell
//        cell.setContentForCell("Today", date: "12.12.2015", temp: "20", imgPath: "/Users/student/Documents/FWPMWeatherApp/FWPMWeatherApp/Assets.xcassets/Foggy.imageset/Foggy.png", rainy: "20%")
        var timeslot:TimeslotMeasured = forecastObj!.daysArray[indexPath.row][0]
        cell.setContentForCell("Saturday", date: timeslot.dateAndTime.description, temp: timeslot.temperatureDescription(), rainy: timeslot.weatherDescription)
        print("cell setted")
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //hier wird der selektierte Tag an den nächsten Controller weiter gegeben
    }
    
    
}