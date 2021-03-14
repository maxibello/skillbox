import UIKit
import YandexMapsMobile
import SnapKit

class YandexVC: UIViewController {
    
    let mapView = YMKMapView()
    let cinemas = CinemasData.cinemas
    private let circleMapObjectTapListener = CinemaMapObjectTapListener()
    
    let TARGET_LOCATION = YMKPoint(latitude: 55.751892, longitude: 37.616821)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setAnchorWithAnchorNormal(
            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { v in
            v.edges.equalToSuperview()
        }
        
        createPoints()
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

extension YandexVC: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        view.pin.useCompositeIcon()
        view.accuracyCircle.fillColor = UIColor.blue
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
    
}
