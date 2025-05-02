//
//  DistanceService.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/2/25.
//

import CoreLocation
import MapKit

final class DistanceService {
    
    static func calculateRouteDistance(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D,
        transportType: MKDirectionsTransportType = .walking,
        completion: @escaping (Double?) -> Void
    ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = transportType
        
        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                completion(route.distance)
            } else {
                completion(nil)
            }
        }
    }
}
