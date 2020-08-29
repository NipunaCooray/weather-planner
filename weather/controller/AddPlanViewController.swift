//
//  AddPlanViewController.swift
//  weather
//
//  Created by Nipuna C on 27/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import UIKit

class AddPlanViewController: UIViewController {
    
    var dataController:DataController!
    var weatherData:DailyWeather?

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var planTitleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBOutlet weak var savePlanButton: UIBarButtonItem!
    @IBOutlet weak var editPlanButton: UIBarButtonItem!
    
    var imageData : Data?
    
    var receivedPlan : WeatherPlan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
        
        initializeHideKeyboard()
    }
    
    func setupViews(){
        
        //Saving a new plan
        if let weatherData = weatherData{
            let date = NSDate(timeIntervalSince1970: Double(weatherData.dt))
            dateText.text = date.description
            weatherText.text = weatherData.weather[0].description
            
            editPlanButton.isEnabled = false
            
            WeatherClient.downloadImage(imageID: weatherData.weather[0].icon) { (imageData, error) in
                
                if let imageData = imageData{
                    self.imageData = imageData
                    self.weatherImageView.image = UIImage(data : imageData)
                }
 
            }
            
            
        }else{
            if let receivedPlan = receivedPlan{
                let date = NSDate(timeIntervalSince1970: Double(receivedPlan.planDate))
                dateText.text = date.description
                
                weatherText.text = receivedPlan.weatherDescription
                editPlanButton.isEnabled = false
                weatherImageView.image = UIImage(data: receivedPlan.image!)
                
                planTitleTextField.text = receivedPlan.planTitle
                noteTextField.text = receivedPlan.note
                
                planTitleTextField.isEnabled = false
                noteTextField.isEditable = false
                
                savePlanButton.isEnabled = false
                
            }

        }

    }
    

    @IBAction func savePlanOnClick(_ sender: Any) {
        
        //WeatherData availability means this is a new plan
        if let weatherData = weatherData{
            let planDate = weatherData.dt
            let weatherDescription = weatherData.weather[0].description
            let creationDate = Date()
            let iconID = weatherData.weather[0].icon
            let planTitle = planTitleTextField.text!
            let note = noteTextField.text!
            let image = self.imageData!
            
            
            let planEntry = WeatherPlan(context: dataController.viewContext)
            planEntry.planDate = Int32(planDate)
            planEntry.creationDate = creationDate
            planEntry.weatherDescription = weatherDescription
            planEntry.iconID = iconID
            planEntry.planTitle = planTitle
            planEntry.note = note
            planEntry.image = image
            
            
            try? dataController.viewContext.save()
            
            let alert = UIAlertController(title: "Plan saved", message: "Your plan is successfully saved", preferredStyle: UIAlertController.Style.alert)
            //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler: { action in
                  switch action.style{
                  case .default:
 
                        
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


            }}))
            
            self.present(alert, animated: true, completion: nil)

        }
        
        
    }
    
    
    @IBAction func editPlanOnClick(_ sender: Any) {
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddPlanViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

