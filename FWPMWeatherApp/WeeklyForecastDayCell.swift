//
//  WeeklyForecastDayCell.swift
//  FWPMWeatherApp
//
//  Created by student on 12.12.15.
//  Copyright © 2015 de.fhws.k28316. All rights reserved.
//

import UIKit

class WeeklyForecastDayCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTempAM: UILabel!
    //@IBOutlet weak var imgAM: UIImageView!
    @IBOutlet weak var lblRainyAM: UILabel!
    
//    func setContentForCell(day:String, date:String, temp:String, imgPath:String, rainy:String) {
//        lblDay.text = day
//        lblDate.text = date
//        lblTempAM.text = temp
//        //imgAM = UIImageView(image: UIImage(named: imgPath))
//        lblRainyAM.text = rainy
//    }
    
    func setContentForCell(day:String, date:String, temp:String, rainy:String) {
        lblDay.text = day
        lblDate.text = date
        lblTempAM.text = temp
        //imgAM = UIImageView(image: UIImage(named: imgPath))
        lblRainyAM.text = rainy
    }
    
}
