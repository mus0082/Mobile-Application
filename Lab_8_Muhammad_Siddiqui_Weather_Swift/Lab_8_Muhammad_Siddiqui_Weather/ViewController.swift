//
//  ViewController.swift
//  Lab_8_Muhammad_Siddiqui_Weather
//
//  Created by user229166 on 7/25/23.
//

import UIKit
import Foundation
import CoreLocation

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
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

// MARK: - Main
struct Main: Codable {
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

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let mapManager = CLLocationManager();
      
    @IBOutlet weak var cityName: UILabel!
       
    @IBOutlet weak var weatherDescription: UILabel!
       
    @IBOutlet weak var weatherIcon: UIImageView!
       
    @IBOutlet weak var weatherTemperature: UILabel!
           
    @IBOutlet weak var weatherHumidity: UILabel!
        
    @IBOutlet weak var windSpeed: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     // the location of stimulate

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        mapManager.delegate = self;
        mapManager.requestWhenInUseAuthorization();
        mapManager.startUpdatingLocation()

 }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation])
    {
        if let location = location.first {
            location.coordinate.latitude
            location.coordinate.longitude
            weatherDataFetch(lat:location.coordinate.latitude, lon:location.coordinate.longitude)
        }
    }
    

    func weatherDataFetch(lat: Double, lon: Double){
    let stringForUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=d17e8e7c2aa7fbce370c47af18d4b8ac"

    let urlSession = URLSession(configuration: .default)
    let url = URL(string: stringForUrl)
           
    if let url =  url {
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print(data)
                    let jsonDecoder = JSONDecoder()
                    do {
                        let readableData = try jsonDecoder.decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                                          self.valueForlabedData(with: readableData)
                        }
                    }catch{
                        print("Can't decode!")
                    }
              
                }
        }
        dataTask.resume()

        }
    }
    func valueForlabedData(with data: Weather){
        cityName.text = data.name
        weatherDescription.text = data.weather.first?.description.capitalized ?? "N/A"
            let url = URL(string: "https://openweathermap.org/img/wn/\(data.weather[0].icon)@2x.png")
            
          if let url = url {
                weatherIcon.load(url: url)
            }
        
        let convertTemperatureToCelsius = data.main.temp - 273.15
        weatherTemperature.text = "\(String(format: "%.1f", convertTemperatureToCelsius)) °C"
        weatherHumidity.text = "\(data.main.humidity) %"
        windSpeed.text = "\(data.wind.speed) m/s"
    }
}

//Got it from internet
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
