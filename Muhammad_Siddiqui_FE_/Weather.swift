//
//  Weather.swift
//  Muhammad_Siddiqui_FE_8939717
//
//  Created by user229166 on 8/9/23.
//

import UIKit
import CoreLocation
import Foundation


struct Welcome: Codable {
    let coord: Coord
    let weather: [WeatherInfo]
    let base: String
    let main: MainData // Renamed to MainData
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - MainData
struct MainData: Codable { // Renamed to MainData
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherInfo: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

class Weather: UIViewController, CLLocationManagerDelegate {
    
    var latitudeFromWeather: Double = 0.0
      var longitudeFromWeather: Double = 0.0
    
    var isComingFromMainScene: Bool = false
    
    let mapManager = CLLocationManager();
    
    var cityNameFromMain: String?
    
    @IBOutlet weak var forDisplayCityDetails: UITextView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDecription: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var WeatherHumidity: UILabel!
    @IBOutlet weak var WindSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityName = cityNameFromMain {
              if isComingFromMainScene {
                  saveCityToCoreData(cityName: cityName)
              }
              
              weatherDataFetch(cityName: cityName)
          } else {
              print("City name is nil.")
          
      }
        let forMapImage = UIImageView(frame: UIScreen.main.bounds)
        forMapImage.image = UIImage(named: "Clouds.jpg")
        forMapImage.contentMode = .scaleAspectFill
        forMapImage.alpha = 1.0
        view.insertSubview(forMapImage, at: 0)

        mapManager.delegate = self
        mapManager.requestWhenInUseAuthorization()
        mapManager.startUpdatingLocation()
    }
    
    func saveCityToCoreData(cityName: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.getContext()
            
            let newCity = Locationhistory(context: context)
            newCity.name = cityName
            newCity.lat = latitudeFromWeather
            newCity.lon = longitudeFromWeather
            
            do {
                try context.save()
                print("City saved successfully")
            } catch {
                print("Error saving city data to Core Data")
            }
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapManager.delegate = self
        mapManager.requestWhenInUseAuthorization()
        mapManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapManager.stopUpdatingLocation()
            if let cityName = cityNameFromMain {
                weatherDataFetch(cityName: cityName)
            } else {
                print("City name is nil.")
            }
            
        }
    }

    func weatherDataFetch(cityName: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=d17e8e7c2aa7fbce370c47af18d4b8ac"
        print("Fetching data from URL: \(urlString)")

        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, _, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let weatherData = try decoder.decode(Welcome.self, from: data)
                        DispatchQueue.main.async {
                            self.updateUI(with: weatherData)
                        }
                    } catch {
                        print("Error decoding weather data: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    func updateUI(with weatherData: Welcome) {
        cityName.text = weatherData.name
        let coordText = "Latitude: \(weatherData.coord.lat), Longitude: \(weatherData.coord.lon)"
           forDisplayCityDetails.text = "\(coordText)\nCity: \(weatherData.name)"
        
        // Update other UI elements based on weather data
        weatherDecription.text = weatherData.weather.first?.description
        // You can update other labels and UI elements similarly
        
        WeatherHumidity.text = "\(weatherData.main.humidity) %"
           // Update wind speed label
        WindSpeed.text = "\(weatherData.wind.speed) m/s"
        
        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png") {
            weatherIcon.load(url: iconURL)
        }
        
        // For example, to update temperature label:
        weatherTemperature.text = "\(weatherData.main.temp) °C"
        
        // Similarly, update other UI elements as needed
        print("City Name: \(weatherData.name)")
           print("Weather Description: \(weatherDecription.text ?? "N/A")")
           print("Temperature: \(weatherTemperature.text ?? "N/A")")
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
