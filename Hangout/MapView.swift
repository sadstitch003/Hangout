//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @StateObject private var coordinator = Coordinator()
    
    
    var body: some View {
        VStack {
            Map(position: $position) {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapPitchToggle()
            }
            .onAppear {
                coordinator.requestLocation()
            }

            if let userLocation = coordinator.userLocation {
                Text("Current Location: \(userLocation.latitude), \(userLocation.longitude)")
                    .padding()
            } else {
                Text("Loading location...")
                    .padding()
            }
        }
    }
}

class Coordinator: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            userLocation = location
        }
    }
}



