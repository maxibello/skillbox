import Foundation

import Foundation
import MapKit
import Contacts

class Cinema: NSObject, MKAnnotation {
  let title: String?
    let subtitle: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    subtitle: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate

    super.init()
  }
  
  init?(feature: MKGeoJSONFeature) {
    guard
      let point = feature.geometry.first as? MKMultiPoint,
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }
    coordinate = point.coordinate
    
    let attributes = properties["Attributes"] as? [String: Any]
    title = attributes?["CommonName"] as? String
    subtitle = ((attributes?["PublicPhone"] as? [[String: Any]])?.first?["PublicPhone"] as? [String])?.first
    
    super.init()
  }

}
