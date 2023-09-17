//
//  Main.swift
//  Muhammad_Siddiqui_FE_8939717
//
//  Created by user229166 on 8/9/23.
//


import UIKit
import Foundation
import CoreLocation
import CoreData

class Main: UIViewController {

    @IBOutlet weak var getCityName: UITextField!
    
    var lastFetchedLatitude: Double?
    var lastFetchedLongitude: Double?

    @IBAction func mapButtonResult(_ sender: UIButton) {
        if let cityName = getCityName.text, !cityName.isEmpty {
            gettingCityFromApi(cityName)
        } else {
            showInvalidCityAlert()
        }
    }
      
    func saveCityToCoreData(cityName: String, lat: Double, lon: Double) {
        print("Saving city to Core Data: \(cityName), Lat: \(lat), Lon: \(lon)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.getContext()
        
        let newCity = Locationhistory(context: context)
        newCity.name = cityName
        newCity.lat = lat
        newCity.lon = lon
        
        DispatchQueue.main.async {
            do {
                try context.save()
                print("City saved successfully")
                self.fetchCityHistory()
            } catch {
                print("Error saving city data to Core Data")
            }
    }
    }
    
    func fetchCityHistory() -> [Locationhistory] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }

        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<Locationhistory> = Locationhistory.fetchRequest()
            let historyList = try context.fetch(fetchRequest)
            print("Fetched city history: \(historyList)")
            return historyList
        } catch {
            print("Error fetching city history: \(error)")
            return []
        }
    }
    
    @objc func disappearKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    func gettingCityFromApi(_ cityName: String) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=d17e8e7c2aa7fbce370c47af18d4b8ac"
              
        let urlSession = URLSession(configuration: .default)//fetching data from a URL.
        let url = URL(string: urlString)
        
        if let url =  url {
            let task = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                if let coord = json["coord"] as? [String: Any],
                                   let latitude = coord["lat"] as? Double,
                                   let longitude = coord["lon"] as? Double {
                                    self.lastFetchedLatitude = latitude
                                    self.lastFetchedLongitude = longitude
                                    
                                    DispatchQueue.main.async {
                                        self.saveCityToCoreData(cityName: cityName, lat: latitude, lon: longitude)
                                        self.performSegue(withIdentifier: "mapSague", sender: (cityName, latitude, longitude))
                                    }
                                } else {
                                    self.showInvalidCityAlert()
                                }
                            } else {
                                self.showInvalidCityAlert()
                        }
                    } catch {
                        self.showInvalidCityAlert()
                    }
                } else {
                    self.showInvalidCityAlert()
                }
            })
            task.resume()
        } else {
            showInvalidCityAlert()
        }
    }
    
    func showInvalidCityAlert() {
        let showAlert = UIAlertController(title: "Invalid City Name", message: "Please enter a valid city name.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert.addAction(okButton)
        present(showAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "mapSague" {
                if let mapScreen = segue.destination as? Map_Scene, let data = sender as? (String, Double, Double) {
                    let (cityName, latitude, longitude) = data
                    mapScreen.cityName = cityName
                    mapScreen.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
               }
            } else if segue.identifier == "weatherSegue" {
                if let destinationVC = segue.destination as? Weather {
                    destinationVC.cityNameFromMain = getCityName.text
                    destinationVC.latitudeFromWeather = lastFetchedLatitude ?? 0.0
                    destinationVC.longitudeFromWeather = lastFetchedLongitude ?? 0.0
                    destinationVC.isComingFromMainScene = true
                    
                         
                }else if segue.identifier == "HistorySegue" {
                    print("Preparing for HistorySegue...")
                     if let destinationVC = segue.destination as? History {
                         // Pass the city data and latitude/longitude to the History scene
                         if let cityName = getCityName.text,
                            let lat = lastFetchedLatitude,
                            let lon = lastFetchedLongitude {
                          
                             destinationVC.historyList = fetchCityHistory()
                         }
                    }
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tGesture = UITapGestureRecognizer(target: self, action: #selector(disappearKeyboard))
        view.addGestureRecognizer(tGesture)
        
        let forViewImage = UIImageView(frame: UIScreen.main.bounds)
        forViewImage.image = UIImage(named: "Milford.jpg")
        forViewImage.contentMode = .scaleAspectFill
        forViewImage.alpha = 0.50
        view.insertSubview(forViewImage, at: 0)
    }
}

