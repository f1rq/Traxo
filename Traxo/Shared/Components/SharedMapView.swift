//
//  SharedMapView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 07/04/2026.
//

import SwiftUI
import MapKit

struct SharedMapView: UIViewRepresentable {
    let isInteractive: Bool
    var routeCoordinates: [CLLocationCoordinate2D] = []

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.isRotateEnabled = false
        map.isPitchEnabled = false
        map.showsCompass = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        map.delegate = context.coordinator
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        map.isScrollEnabled = isInteractive
        map.isZoomEnabled = isInteractive
        map.isUserInteractionEnabled = isInteractive

        let currentCount = (map.overlays.first as? MKPolyline)?.pointCount ?? 0
        guard routeCoordinates.count != currentCount else { return }
        
        map.removeOverlays(map.overlays)
        
        guard routeCoordinates.count > 1 else {
            if let first = routeCoordinates.first {
                let region = MKCoordinateRegion(
                    center: first,
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
                map.setRegion(region, animated: true)
            }
            return
        }
        
        var coords = routeCoordinates
        let polyline = MKPolyline(coordinates: &coords, count: coords.count)
        map.addOverlay(polyline, level: .aboveRoads)
        
        if isInteractive {
            let lastCoord = routeCoordinates[routeCoordinates.count - 1]
            let region = MKCoordinateRegion(
                center: lastCoord,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            map.setRegion(region, animated: true)
        } else {
            map.setVisibleMapRect(
                polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: false
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ map: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 5
                renderer.lineCap = .round
                renderer.lineJoin = .round
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
