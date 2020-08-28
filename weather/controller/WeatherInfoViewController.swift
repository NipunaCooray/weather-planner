//
//  WeatherInfoViewController.swift
//  weather
//
//  Created by Nipuna C on 27/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import UIKit

class WeatherInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "weatherInfoCell"
    
    var dataController:DataController!
    
    var weatherResponse:WeatherResponse!
    
    var weatherData:DailyWeather?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "goToAddPlanVC" {
            let destinationVC = segue.destination as! AddPlanViewController
            destinationVC.dataController = dataController
            destinationVC.weatherData = weatherData
        
       }
    }
    
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return weatherResponse.daily.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let weatherData = self.weatherResponse.daily[(indexPath as NSIndexPath).row]
     
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WeatherInfoTableCell
        cell.timezoneText?.text = self.weatherResponse.timezone
        
        let date = NSDate(timeIntervalSince1970: Double(weatherData.dt))
        
        cell.dateText?.text = date.description
        
        cell.descriptionText?.text = weatherData.weather[0].description
        
    

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.weatherData = self.weatherResponse.daily[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "goToAddPlanVC", sender: self)
    }
    

}
