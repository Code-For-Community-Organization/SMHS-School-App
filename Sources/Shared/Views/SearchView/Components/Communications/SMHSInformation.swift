//
//  SMHSInformation.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/3/21.
//

import SwiftUI

struct SMHSInformation: View {
    var body: some View {
        VStack {
            Text("Contact SMCHS")
                .font(.title, weight: .bold)
                .textAlign(.leading)
                .padding(.top, 20)
                .padding(.bottom, 10)
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
    }
}

struct SMHSInformation_Previews: PreviewProvider {
    static var previews: some View {
        SMHSInformation()
    }
}
