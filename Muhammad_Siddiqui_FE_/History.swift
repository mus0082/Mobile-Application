//
//  History.swift
//  Muhammad_Siddiqui_FE_8939717
//
//  Created by user229166 on 8/13/23.
//

import CoreData
import UIKit
import MapKit
import CoreLocation

class History: UITableViewController {
    
    var forWeatherCityName : String?
    @IBOutlet var myHistoryList: UITableView!
    var historyList: [Locationhistory]?
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myHistoryList.delegate = self
        myHistoryList.dataSource = self
        fetchCityHistory()
        myHistoryList.register(UITableViewCell.self, forCellReuseIdentifier: "personCell")
    }
    
    func fetchCityHistory() {
        do {
            self.historyList = try content.fetch(Locationhistory.fetchRequest())
            DispatchQueue.main.async {
                self.myHistoryList.reloadData()
            }
        } catch {
            print("Error fetching city history from Core Data")
        }
    }

    @IBAction func addCity(_ sender: Any) {
        let alert = UIAlertController(title: "Add City", message: "Enter city details", preferredStyle: .alert)
       
        alert.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Latitude"
        }

        alert.addTextField { textField in
            textField.placeholder = "Longitude"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let cityName = alert.textFields?.first?.text,
               let latString = alert.textFields?[1].text,
               let lonString = alert.textFields?[2].text,
               let latitude = Double(latString),
               let longitude = Double(lonString) {
                self.saveCityToCoreData(cityName: cityName, lat: latitude, lon: longitude)
             
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func saveCityToCoreData(cityName: String, lat: Double, lon: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.getContext()
        
        let newCity = Locationhistory(context: context)
        newCity.name = cityName
        newCity.lat = lat
        newCity.lon = lon
        
        do {
            try context.save()
            print("City saved successfully")
            fetchCityHistory() // Refresh the table view with updated data
        } catch {
            print("Error saving city data to Core Data")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = myHistoryList.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
            if let cityData = self.historyList?[indexPath.row] {
                    let roundedLat = String(format: "%.2f", cityData.lat)
                    let roundedLon = String(format: "%.2f", cityData.lon)
                cell.textLabel?.text = "\(cityData.name) - Lat: \(roundedLat), Lon: \(roundedLon)"
        
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cityData = self.historyList?[indexPath.row] {
            let cityName = cityData.name
            let lat = cityData.lat
            let lon = cityData.lon
            
            // Create an alert to display options for the selected city
            let alert = UIAlertController(title: cityName, message: nil, preferredStyle: .actionSheet)
            
            // Add action for the Map option
            let mapAction = UIAlertAction(title: "Map", style: .default) { _ in
                if let cityName = cityName {
                    self.performSegue(withIdentifier: "mapSague", sender: (cityName, lat, lon))
                    }
            }
            alert.addAction(mapAction)
            
            // Add action for the Weather option
            let weatherAction = UIAlertAction(title: "Weather", style: .default) { _ in
                if let cityName = cityName {
                    self.forWeatherCityName = cityName
                    self.performSegue(withIdentifier: "weatherSegue", sender: (cityName, lat, lon))
                    
                    //self.navigateToWeatherScene(cityName: cityName)
                    }
            }
            alert.addAction(weatherAction)
            
            // Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            // Present the alert
            present(alert, animated: true, completion: nil)
        }
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
                    destinationVC.cityNameFromMain = forWeatherCityName
                    if let cityData = sender as? (String, Double, Double) {
                        destinationVC.latitudeFromWeather = cityData.1 // Replace with actual latitude value
                        destinationVC.longitudeFromWeather = cityData.2 // Replace with actual longitude value
                              }
                     destinationVC.isComingFromMainScene = true
                    
                               
                    }
                }
            }
        

//    func navigateToMapScene(cityName: String, lat: Double, lon: Double) {
//
//
//        if let mapScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapSague") as? Map_Scene {
//            mapScene.cityName = cityName
//            mapScene.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//            navigationController?.pushViewController(mapScene, animated: true)
//        }
//    }
//
//    func navigateToWeatherScene(cityName: String) {
//
//        if let weatherScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherSegue") as? Weather {
//            weatherScene.cityNameFromMain = cityName
//            navigationController?.pushViewController(weatherScene, animated: true)
//        }
//
//    }
 
     // implement swipe-to-delete functionality

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cityToRemove = self.historyList?[indexPath.row] {
                content.delete(cityToRemove)
                
                do {
                    try content.save()
                    fetchCityHistory()
                } catch {
                    print("Error saving data")
                
            }
        }
    }
}
    // Implement the rest of the CLLocationManagerDelegate methods here





/*
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

    // Configure the cell...

    return cell
}
*/

/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}
*/

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
}
