//
//  SharedMapView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 07/04/2026.
//

import SwiftUI
import MapKit

final class SharedMapHost {
    static let shared = SharedMapHost()
    let mapView = MKMapView()

    private init() {
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.showsCompass = false
        mapView.showsScale = false
    }

    func warmUp() {
        DispatchQueue.main.async {
            self.mapView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            self.mapView.layoutIfNeeded()
        }
    }
}


struct SharedMapView: UIViewRepresentable {
    let isInteractive: Bool

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.clipsToBounds = true
        return container
    }

    func updateUIView(_ container: UIView, context: Context) {
        let map = SharedMapHost.shared.mapView
        map.isScrollEnabled = isInteractive
        map.isZoomEnabled = isInteractive
        map.isUserInteractionEnabled = isInteractive

        if map.superview !== container {
            map.removeFromSuperview()
            map.frame = container.bounds
            map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(map)
        }
    }

    static func dismantleUIView(_ container: UIView, coordinator: ()) {
        SharedMapHost.shared.mapView.removeFromSuperview()
    }
}
