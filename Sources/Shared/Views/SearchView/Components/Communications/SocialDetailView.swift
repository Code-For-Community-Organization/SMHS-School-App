//
//  SocialDetailView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}
struct SocialDetailView: View {
    @State var region = MKCoordinateRegion(center: .init(latitude: 33.64304533631487,
                                                         longitude: -117.58231905977404),
                                           span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
    let markers = [Marker(location: MapMarker(coordinate: .init(latitude: 33.64304533631487,
                                                                longitude: -117.58231905977404),
                                              tint: Color(hexadecimal: "0736A4")))]
    var body: some View {
        ScrollView {
            VStack {
                SMStretchyHeader()
                VStack {
                    Text("Social Medias")
                        .font(.title, weight: .bold)
                        .textAlign(.leading)
                        .padding(.top)
                        .padding(.bottom, 10)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("Tap to get the newest SMCHS updates on social medias.")
                        .font(.callout, weight: .medium)
                        .foregroundColor(.platformSecondaryLabel)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .textAlign(.leading)
                        .padding(.bottom)
                    SocialMediaIcons()
                    Divider()
                    Group {
                        Text("Contact SMCHS")
                            .font(.title, weight: .bold)
                            .textAlign(.leading)
                            .padding(.vertical)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Text("General Inquries")
                            .font(.title3, weight: .bold)
                            .textAlign(.leading)
                            .foregroundColor(.platformSecondaryLabel)
                            .padding(.bottom)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        HStack {
                            Text("Phone:")
                                .font(.body, weight: .semibold)
                            Link("949-766-6000", destination: URL(string: "tel:9497666000")!)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        HStack {
                            Text("Fax:")
                                .font(.body, weight: .semibold)
                            Link("949-766-6005", destination: URL(string: "tel:9497666005")!)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        Text("Attendance or Dean's Office")
                            .font(.title3, weight: .bold)
                            .textAlign(.leading)
                            .foregroundColor(.platformSecondaryLabel)
                            .padding(.vertical)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        HStack {
                            Text("Phone:")
                                .font(.body, weight: .semibold)
                            Link("949-766-6000", destination: URL(string: "tel:9497666000")!)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        .padding(.bottom)
                    }
                    Text("Please call attendance/dean's office regarding: ")
                        .font(.callout, weight: .medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .textAlign(.leading)
                        .padding(.bottom)
                    Group {
                        Text("\u{2022} Abensce and Tardienss").textAlign(.leading)
                        Text("\u{2022} Dress code").textAlign(.leading)
                        Text("\u{2022} Detentions").textAlign(.leading)
                        Text("\u{2022} Disciplinary problems").textAlign(.leading)
                        Text("\u{2022} Theft and vandalism").textAlign(.leading)
                        Text("\u{2022} Parking permits").textAlign(.leading)
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.platformSecondaryLabel)
                    Divider()
                    Text("School Location")
                        .font(.title, weight: .bold)
                        .textAlign(.leading)
                        .padding(.vertical)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Group {
                        Text("Address: ")
                            .font(.body, weight: .semibold)
                            .textAlign(.leading)
                        Text("22062 Antonio Parkway\nRancho Santa Margarita, CA 92688")
                            .font(.callout, weight: .regular)
                            .textAlign(.leading)
                            .foregroundColor(.platformSecondaryLabel)
                            .padding(.bottom)
                            .lineLimit(nil)
                        Button(action: openDirectionsInMap, label: {
                            Label("Get Directions", systemSymbol: .locationFill)
                                .font(.body, weight: .semibold)
                        })
                        .buttonStyle(HighlightButtonStyle())
                        .padding(.bottom)
                        Map(coordinateRegion: $region, interactionModes: .zoom, showsUserLocation: false, annotationItems: markers) {marker in
                            marker.location
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .roundedCorners(cornerRadius: 10)
                    }
                    
                }
                .padding(.horizontal)
                Spacer()
            }
        }

    }
    
    func openDirectionsInMap() {
        let coordinate = CLLocationCoordinate2DMake(33.64304533631487, -117.58231905977404)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Santa Margarita Catholic High School"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

}

struct SocialDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SocialDetailView()
    }
}
