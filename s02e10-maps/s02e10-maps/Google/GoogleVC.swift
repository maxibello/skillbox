import UIKit
import GoogleMaps

class GoogleVC: UIViewController {
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    let cinemas = CinemasData.cinemas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: 55.751892, longitude: 37.616821, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        self.view.addSubview(mapView)
        
        for cinema in cinemas {
            let marker = CinemaGMSMarker(cinema: cinema)
            marker.map = mapView
        }
        
    }
}

extension GoogleVC: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}

extension GoogleVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let cinemaMarker = marker as? CinemaGMSMarker,
              let cinemaTitle = cinemaMarker.cinema.title else {
            return false
        }
        print("Вы выбрали: " + cinemaTitle)
        return false
    }
}
