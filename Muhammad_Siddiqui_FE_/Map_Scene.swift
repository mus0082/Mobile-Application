//
//  Map_Scene.swift
//  Muhammad_Siddiqui_FE_8939717
//
//  Created by user229166 on 8/12/23.
//

import UIKit
import MapKit
import CoreLocation

class Map_Scene: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let mapManager = CLLocationManager();

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var forZoomSlider: UISlider!
    @IBOutlet weak var myLoc: MKMapView!
    
    var cityName: String?
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLoc.delegate = self
        mapManager.requestWhenInUseAuthorization();
        
        
        if let cityName = cityName, let coordinates = coordinates {
            textView.text = "City: \(cityName)\nLatitude: \(coordinates.latitude)\nLongitude: \(coordinates.longitude)"
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
            myLoc.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            myLoc.addAnnotation(annotation)
        }
            let forMapImage = UIImageView(frame: UIScreen.main.bounds)
            forMapImage.image = UIImage(named: "Map.jpeg")
            forMapImage.contentMode = .scaleAspectFill
            forMapImage.alpha = 1.0
            view.insertSubview(forMapImage, at: 0)
        
    }
    
    @IBAction func zoomSliderValueChanged(_ sender: UISlider) {
        let zoomLevel = Double(sender.value)
        let region = MKCoordinateRegion(center: coordinates ?? CLLocationCoordinate2D(), latitudinalMeters: zoomLevel * 10000, longitudinalMeters: zoomLevel * 10000)
        myLoc.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        return pinView
    }
}
