import Foundation

import MapKit

class CinemaMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let cinema = newValue as? Cinema else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        markerTintColor = .yellow
        
        glyphText = "🎥"

      // 2
//      markerTintColor = artwork.markerTintColor
//      if let letter = artwork.discipline?.first {
//        glyphText = String(letter)
//      }
    }
  }
}
