//
//  ViewController.swift
//  s02e09-maps
//
//  Created by Maxim Kuznetsov on 10.01.2021.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapKitVC: UIViewController {

    var cinemas: [Cinema] = []
    let mapView = MKMapView()
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
//            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        
        
        let initialLocation = CLLocation(latitude: 55.751892, longitude: 37.616821)
        mapView.centerToLocation(initialLocation)
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        let userTackingButton = MKUserTrackingButton(mapView: mapView)


        //TODO: центрирования по точкам кинотеатров
        let regionCenter = CLLocation(latitude: 55.751892, longitude: 37.616821)
        let region = MKCoordinateRegion(
          center: regionCenter.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)

//        let test = MKCoordinateReg
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
//         Show artwork on map
//        mapView.register(
//          ArtworkMarkerView.self,
//          forAnnotationViewWithReuseIdentifier:
//            MKMapViewDefaultAnnotationViewReuseIdentifier)
//
//        mapView.register(
//          ArtworkView.self,
//          forAnnotationViewWithReuseIdentifier:
//            MKMapViewDefaultAnnotationViewReuseIdentifier)


        loadInitialData()
        mapView.addAnnotations(cinemas)
        
        mapView.addSubview(userTackingButton)
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { v in
            v.edges.equalToSuperview()
        }
        
        userTackingButton.snp.makeConstraints { v in
            v.bottom.equalToSuperview().offset(-10)
            v.trailing.equalToSuperview().offset(-10)
        }
        
    }


    private func loadInitialData() {
      // 1
      guard
        let fileName = Bundle.main.url(forResource: "cinemas", withExtension: "geojson"),
        let cinemasData = try? Data(contentsOf: fileName)
//        print("cinemasData: \(cinemasData)")
        else {
          return
      }

        print("cinemasData: \(cinemasData)")
      do {
        // 2
        let features = try MKGeoJSONDecoder()
          .decode(cinemasData)
          .compactMap { $0 as? MKGeoJSONFeature }
        // 3
        let validWorks = features.compactMap(Cinema.init)
        // 4
        cinemas.append(contentsOf: validWorks)
      } catch {
        // 5
        print("Unexpected error: \(error).")
      }
        
        mapView.register(
          CinemaMarkerView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
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

extension MapKitVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//
//                }
//            }
//        }
//    }
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

