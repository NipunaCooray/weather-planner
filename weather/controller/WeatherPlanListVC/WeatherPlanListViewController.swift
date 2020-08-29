//
//  ViewController.swift
//  weather
//
//  Created by Nipuna C on 24/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import SystemConfiguration

class WeatherPlanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let reuseIdentifier = "weatherPlanCell"
    
    //This dataController is injected from the SceneDelegare
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<WeatherPlan>!
    
    var weatherResponse : WeatherResponse?
    
    var planToInject : WeatherPlan?
    
    @IBOutlet weak var addPlanButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var lat : Double?
    var long : Double?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showAlert()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        //print(WeatherClient.Endpoints.searchURLString(-33.865143, 151.209900).url)
        locationManager.delegate =  self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        tableView.dataSource = self
        tableView.delegate = self
        
        addPlanButton.isEnabled = false
        
        setupFetchedResultsController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Inside viewWillAppear on MAIN VC")
        setupFetchedResultsController()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       fetchedResultsController = nil
    }
    
    fileprivate func setupFetchedResultsController(){
        let fetchRequest:NSFetchRequest<WeatherPlan> = WeatherPlan.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key:"creationDate",ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("The fetch cannot be performed")
        }
        
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func deletePlan(at indexPath: IndexPath) {
        let planToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(planToDelete)
        try? dataController.viewContext.save()
    }

    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let planData = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WeatherPlanCell
        cell.planTitle?.text = planData.planTitle
        cell.dateLabel?.text = planData.weatherDescription

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.planToInject = fetchedResultsController.object(at: indexPath)

         performSegue(withIdentifier: "goDirectToAddPlanVC", sender: self)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deletePlan(at: indexPath)
        default: () // Unsupported
        }
    }
    
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToWeatherInfoView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "goToWeatherInfoView" {
            let destinationVC = segue.destination as! WeatherInfoViewController
            destinationVC.dataController = dataController
            destinationVC.weatherResponse = weatherResponse
        
       }else if segue.identifier == "goDirectToAddPlanVC" {
            let destinationVC = segue.destination as! AddPlanViewController
            destinationVC.dataController = dataController
            destinationVC.receivedPlan = planToInject
            
        
       }
    }
    

}

//MARK: -CLLocationManagerDelegate

extension WeatherPlanListViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last{
            self.lat = location.coordinate.latitude
            self.long = location.coordinate.longitude
            
            WeatherClient.fetchSevenDayWeatherData(lat: lat!, long: long!){(weatherResponse,error) in
                
                
               
                if let weatherResponse = weatherResponse{
                    self.weatherResponse = weatherResponse
                    self.addPlanButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                }
                
            }
            
        }
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


