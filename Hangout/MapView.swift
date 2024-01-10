import SwiftUI
import MapKit
import FirebaseFirestore
import Combine

struct MapView: View {
    @AppStorage("appUsername") var appUsername: String?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.285617, longitude: 112.68087),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    @StateObject private var coordinator = Coordinator()
    @State private var firestoreLocations: [FirestoreLocation] = []

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $coordinator.userTrackingMode, annotationItems: coordinator.annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.26, green: 0.58, blue: 0.97))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 31, height: 31)
                        )
                        .overlay(
                            Text(String(annotation.friendName.prefix(1)))
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .padding(.trailing, 5)
                        .onTapGesture {
                            coordinator.selectedFriend = annotation
                        }

                    if let selectedFriend = coordinator.selectedFriend, selectedFriend.id == annotation.id {
                        Text(selectedFriend.friendName)
                            .foregroundColor(.black)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                            .offset(y: -40)
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
                .padding()
        }
        .onAppear {
            coordinator.requestLocation()
            startFetchingDataTimer()
        }
    }

    private func startFetchingDataTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            
            fetchFirestoreData()
            updateLocation()
        }
    }

    func updateLocation() {
        let db = Firestore.firestore()
        
        guard let username = appUsername,
              let userLatitude = coordinator.userLocation?.latitude,
              let userLongitude = coordinator.userLocation?.longitude else {
            return
        }

        let locations: [String: Any] = [
            "latitude": "\(userLatitude)",
            "longitude": "\(userLongitude)"
        ]
        
        db.collection("locations")
            .whereField("username", isEqualTo: username)
            .getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in querySnapshot!.documents {
                       let documentRef = document.reference
                       documentRef.updateData(locations) { error in
                           if let error = error {
                               print("Error updating document: \(error)")
                           } else {
                               print("Document updated!")
                           }
                       }
                   }
               }
           }
    }
    
    func fetchFirestoreData() {
        let db = Firestore.firestore()
        var friends: [String] = []
        guard let username = appUsername else {
            return
        }

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        db.collection("friends")
            .whereField("username", isEqualTo: username)
            .getDocuments { querySnapshot, error in
                defer {
                    dispatchGroup.leave()
                }
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        for field in document.data() {
                            if field.key != "username" {
                                friends.append(field.key)
                            }
                            print(friends)
                        }
                    }
                }
            }

        dispatchGroup.notify(queue: .main) {
            if friends.count > 0 {
                self.fetchLocations(for: friends)
            }
        }
    }

    func fetchLocations(for friends: [String]) {
        let db = Firestore.firestore()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        db.collection("locations")
            .whereField("username", in: friends)
            .getDocuments { snapshot, error in
                defer {
                    dispatchGroup.leave()
                }
                if let error = error {
                    print("Error fetching Firestore data: \(error.localizedDescription)")
                } else {
                    firestoreLocations = snapshot?.documents.compactMap { document in
                        guard
                            let latitude = document["latitude"] as? String,
                            let longitude = document["longitude"] as? String,
                            let name = document["name"] as? String,
                            let username = document["username"] as? String
                        else {
                            print("Failed to parse Firestore data for document \(document.documentID)")
                            print("Document Data: \(document.data())")
                            return nil
                        }

                        let firestoreLocation = FirestoreLocation(latitude: latitude, longitude: longitude, name: name, username: username)
                        print("Firestore Data for document \(document.documentID): \(firestoreLocation)")
                        return firestoreLocation
                    } ?? []

                    updateAnnotations()
                }
            }

        dispatchGroup.notify(queue: .main) {
            // This will be called when both fetch operations are complete
            print("Both fetch operations are complete")
        }
    }

    func updateAnnotations() {
        coordinator.annotations = firestoreLocations.compactMap { firestoreLocation in
            if let latitude = Double(firestoreLocation.latitude),
               let longitude = Double(firestoreLocation.longitude) {
                return PinAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    title: firestoreLocation.name,
                    friendName: firestoreLocation.name
                )
            } else {
                // Handle the case where latitude or longitude cannot be converted to Double
                print("Failed to convert latitude or longitude to Double for \(firestoreLocation.name)")
                return nil
            }
        }
    }
}

class Coordinator: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var annotations: [PinAnnotation] = []
    @Published var selectedFriend: PinAnnotation?
    @Published var userTrackingMode: MapUserTrackingMode = .follow
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

struct PinAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let friendName: String
}

struct FirestoreLocation: Codable {
    let latitude: String
    let longitude: String
    let name: String
    let username: String
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
