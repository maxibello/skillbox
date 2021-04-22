import UIKit
import MapKit
import CoreLocation

class CinemasData {
    private static var _cinemas: [Cinema] = []
    static var cinemas: [Cinema] {
        guard _cinemas.count == 0 else { return _cinemas }
        return loadInitialData()
    }
    
    private static func loadInitialData() -> [Cinema] {
        guard
            let fileName = Bundle.main.url(forResource: "cinemas", withExtension: "geojson"),
            let cinemasData = try? Data(contentsOf: fileName)
        else {
            return []
        }
        do {
            let features = try MKGeoJSONDecoder()
                .decode(cinemasData)
                .compactMap { $0 as? MKGeoJSONFeature }
            let validWorks = features.compactMap(Cinema.init)
            _cinemas.append(contentsOf: validWorks)
        } catch {
            print("Unexpected error: \(error).")
        }
        
        return _cinemas
    }
}
