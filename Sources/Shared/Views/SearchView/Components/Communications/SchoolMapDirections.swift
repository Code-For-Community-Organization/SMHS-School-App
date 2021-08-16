//
//  SchoolMapDirections.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/3/21.
//

import MapKit
import SwiftUI

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct SchoolMapDirections: View {
    @State var region = MKCoordinateRegion(center: .init(latitude: 33.64304533631487,
                                                         longitude: -117.58231905977404),
                                           span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
    let markers = [Marker(location: MapMarker(coordinate: .init(latitude: 33.64304533631487,
                                                                longitude: -117.58231905977404),
                                              tint: Color(hexadecimal: "0736A4")))]
    var body: some View {
        Group {
            Text("Address: ")
                .font(.body, weight: .semibold)
                .textAlign(.leading)
            Text("22062 Antonio Parkway, Rancho Santa Margarita, CA 92688")
                .font(.callout, weight: .regular)
                .textAlign(.leading)
                .foregroundColor(.platformSecondaryLabel)
                .padding(.bottom)
                .lineLimit(2)
            Button(action: openDirectionsInMap, label: {
                Label("Get Directions", systemSymbol: .locationFill)
                    .font(.body, weight: .semibold)
            })
                .buttonStyle(HighlightButtonStyle())
                .padding(.bottom)
            Map(coordinateRegion: $region, interactionModes: MapInteractionModes.all, showsUserLocation: false, annotationItems: markers) { marker in
                marker.location
            }
            .frame(height: CGFloat(200))
            .frame(maxWidth: CGFloat.infinity)
            .roundedCorners(cornerRadius: CGFloat(10))
        }
    }

    func openDirectionsInMap() {
        let coordinate = CLLocationCoordinate2DMake(33.64304533631487, -117.58231905977404)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = "Santa Margarita Catholic High School"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

struct SchoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolMapDirections()
    }
}
