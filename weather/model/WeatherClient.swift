//
//  WeatherApi.swift
//  weather
//
//  Created by Nipuna C on 24/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import Foundation

class WeatherClient{
    
    static let apiKey = "c0b7254a0dbd6116103bdf57b55d2d06"
    
    enum Endpoints {
        static let base = "https://api.openweathermap.org/data/2.5/onecall?"
        
        static let image_base = "https://openweathermap.org/img/wn/"
        
        case searchURLString(Double, Double)
        case imageURLString(String)

        var urlString: String {
            switch self {
                 case .searchURLString(let latitude, let longitude):
                   return Endpoints.base +
                        "&lat=\(latitude)" +
                        "&lon=\(longitude)" +
                        "&exclude=minutely,hourly&appid=\(WeatherClient.apiKey)"
            case .imageURLString(let imageID):
                    return Endpoints.image_base + imageID + ".png"
                        
            }
        }
     
       var url: URL {
           return URL(string: urlString)!
       }
    }
    
    class func fetchSevenDayWeatherData(lat : Double,long : Double, completion: @escaping (WeatherResponse?, Error?) -> Void){
        let url = WeatherClient.Endpoints.searchURLString(lat, long).url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let safeData = data else {
               DispatchQueue.main.async {
                   //completion(nil, error)
               }
               return
            }
            
            let decoder = JSONDecoder()

            do{
                let decodedData = try decoder.decode(WeatherResponse.self, from: safeData)
               
                
                DispatchQueue.main.async {
                     completion(decodedData, error)
                }
                
            }catch{
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    
    class func downloadImage(imageID: String  , completion: @escaping (Data?, Error?)-> Void  ){

        let url = WeatherClient.Endpoints.imageURLString(imageID).url

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard let data = data else{
                return
            }

            let imageData = data

            DispatchQueue.main.async {
                completion(imageData, error)
            }

        }

        task.resume()
        
    }
    
}
