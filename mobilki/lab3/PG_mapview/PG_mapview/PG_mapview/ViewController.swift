//
//  ViewController.swift
//  PG_mapview
//
//  Created by Patryk Gałczyński on 24/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {

    //map and address label
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    //buttons
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    //variables
    //var positions:
    var locationManager:CLLocationManager!
    var geocoder = CLGeocoder()
    var markers: [MKPointAnnotation] = []
    var trackPosition = false
    
    
    
    @IBAction func startTracking(sender: UIButton) {
        stopButton.isEnabled = true
        startButton.isEnabled = false
        trackPosition = true
    }
    
    @IBAction func stopTracking(sender: UIButton) {
        stopButton.isEnabled = false
        startButton.isEnabled = true
        trackPosition = false
    }
    
    @IBAction func clearTracking(sender: UIButton) {
        self.mapView.removeAnnotations(markers)
        markers = []
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        if(trackPosition == true) {
            self.mapView.camera.altitude = 10
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = lastLocation.coordinate
            self.mapView.addAnnotation(objectAnnotation)
            markers.append(objectAnnotation)
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemark, error) in
                let pm = placemark![0] as CLPlacemark
                self.addressLabel.text = "\(pm.thoroughfare!), \(pm.locality!), \(pm.isoCountryCode!)"
            })
            if(lastLocation.speed < 5) {
                self.mapView.camera.altitude = 500
            } else if (lastLocation.speed < 10) {
                self.mapView.camera.altitude = 1500
            } else {
                self.mapView.camera.altitude = 5000
            }
        }
        mapView.setCenter(lastLocation.coordinate, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.isEnabled = false
        addressLabel.text = ""
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

