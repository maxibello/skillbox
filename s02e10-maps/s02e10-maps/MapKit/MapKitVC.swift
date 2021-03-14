import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapKitVC: UIViewController {
    
    let mapView = MKMapView()
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        let initialLocation = CLLocation(latitude: 55.751892, longitude: 37.616821)
        mapView.centerToLocation(initialLocation)
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        mapView.register(
            CinemaMarkerView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let userTackingButton = MKUserTrackingButton(mapView: mapView)
        
        let regionCenter = CLLocation(latitude: 55.751892, longitude: 37.616821)
        let region = MKCoordinateRegion(
            center: regionCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.addAnnotations(CinemasData.cinemas)
        
        mapView.addSubview(userTackingButton)
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { v in
            v.edges.equalToSuperview()
        }
        
        userTackingButton.snp.makeConstraints { v in
            v.bottom.equalToSuperview().offset(-100)
            v.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
}

private extension MKMapView {
    
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 15000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius * 2)
        setRegion(coordinateRegion, animated: true)
    }
    
}

extension MapKitVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("Вы выбрали: \(annotationTitle!)")
        }
    }
}

