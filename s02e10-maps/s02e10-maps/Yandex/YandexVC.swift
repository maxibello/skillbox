import UIKit
import YandexMapsMobile
import SnapKit
import CoreLocation

class YandexVC: UIViewController {
    
    let mapView = YMKMapView()
    let cinemas = CinemasData.cinemas
    let locationButton = UIButton(frame: .zero)
    private let circleMapObjectTapListener = CinemaMapObjectTapListener()
    
    let initialLocation = YMKPoint(latitude: 55.751892, longitude: 37.616821)
    private var userLocationLayer: YMKUserLocationLayer!
    private var locationManager: YMKLocationManager!
        private var nativeLocationManager = CLLocationManager()
    private var userLocationPoint: YMKPoint!
    
    var userLocation: YMKPoint? {
            didSet {
                guard userLocation != nil && userLocation?.latitude != 0 && userLocation?.longitude != 0 else { return }
                
                mapView.mapWindow.map.move(
                    with: YMKCameraPosition.init(target: userLocation!, zoom: 10, azimuth: 0, tilt: 0),
                    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                    cameraCallback: nil)
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationButton.setImage(UIImage(named: "UserArrow"), for: .normal)
        locationButton.contentVerticalAlignment = .fill
        locationButton.contentHorizontalAlignment = .fill
        locationButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocation = initialLocation
        
        view.addSubview(mapView)
        view.addSubview(locationButton)
        
        mapView.snp.makeConstraints { v in
            v.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { v in
            v.bottom.equalToSuperview().offset(-100)
            v.trailing.equalToSuperview().offset(-10)
            v.size.equalTo(22)
        }
        
        createPoints()
        setupNativeLocationManager()
    }
    
    @objc func buttonClicked() {
        userLocation = userLocationPoint
    }
    
    func createPoints() {
        
        for cinema in cinemas {
            let mapObjects = mapView.mapWindow.map.mapObjects;
            let center = YMKPoint(latitude: cinema.coordinate.latitude, longitude: cinema.coordinate.longitude)
            let circle = mapObjects.addCircle(
                with: YMKCircle(center: center, radius: 1000),
                stroke: UIColor.green,
                strokeWidth: 2,
                fill: UIColor.red)
            circle.zIndex = 100
            circle.userData = cinema
            
            circle.addTapListener(with: circleMapObjectTapListener)
        }
        
    }

    private func setupNativeLocationManager() {
            if CLLocationManager.locationServicesEnabled() {
                nativeLocationManager.delegate = self
                nativeLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                nativeLocationManager.startUpdatingLocation()
            }
        }
}

private class CinemaMapObjectTapListener: NSObject, YMKMapObjectTapListener {
    private weak var controller: UIViewController?

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let circle = mapObject as? YMKCircleMapObject {

            if let cinema = circle.userData as? Cinema, let title = cinema.title {
                print("Вы выбрали: \(title)")
            }
        }
        return true;
    }
}

extension YandexVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocationPoint = YMKPoint(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
    }
}
