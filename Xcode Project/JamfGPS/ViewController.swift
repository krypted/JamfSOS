//
//  ViewController.swift
//  JamfGPS
//
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        map.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true)
            
            callAPI(location: "(\(location.coordinate.latitude),\(location.coordinate.longitude))")
        }
    }
    
    fileprivate func callAPI(location: String) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "INSERTHOSTNAMEHERE"
        // Note that in the above your hostname would be hostname.jamfcloud.com or something like that
        components.path = "/uapi/inventory/obj/mobileDevice/1/update"
        // Since this is a proof of concept we are just using device id 1 but you would want to make this dynamic in a real app
        guard let url = components.url else { preconditionFailure("Failed to construct URL") }
        
        var request = URLRequest(url: url)
        
        // Recall this is the type of data that we *may* be sending
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("jamf-token [\("token here")]", forHTTPHeaderField: "Authorization")
        //your token would be an encoded username and password but would be better to use the certificate SDK
        request.httpMethod = "POST"
        
        let json: [String: Any] = ["extensionAttributes": ["id": 1, "name": "gps", "type": "STRING", "value": location]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // insert json data to the request
        request.httpBody = jsonData
         
        // ...and recall this specifies the type we want back
        // request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else { // check for networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "")")
        }
         
        task.resume()
    }
}
