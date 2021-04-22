import Foundation
import GoogleMaps

final class CinemaGMSMarker: GMSMarker {
    let cinema: Cinema
    
    init(cinema: Cinema) {
        self.cinema = cinema
        super.init()
        
        position = cinema.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
        title = cinema.title
        snippet = cinema.subtitle
        
        icon = UIImage(named: "film")
    }
}
