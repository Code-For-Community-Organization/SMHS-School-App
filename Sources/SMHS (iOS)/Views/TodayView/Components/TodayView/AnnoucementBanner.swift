//
//  AnnoucementBanner.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/6/21.
//

import SwiftUI

struct AnnoucementBanner: View {
    @StateObject var viewModel: TodayViewViewModel

    var body: some View {
        Button(action: {viewModel.showAnnoucement = true}, label: {
            VStack {
                HStack(alignment: .top) {
                        Label("Daily Announcement", systemSymbol: .megaphoneFill)
                            .font(Font.title3.weight(.semibold))
                            .textAlign(.leading)
                            .padding(.bottom, 10)

                        Image(systemSymbol: .chevronRight)
                            .padding(.top, 2)

                }

                if viewModel.loadingAnnoucements {
                    ProgressView()
                }
                else {
                    if viewModel.isAnnoucementAvailable {
                        Text("Last Updated: \(viewModel.lastUpdateDisplay)")
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                        .padding(.top, 2)
                    }
                    else {
                        Label(
                            title: { Text("Unavailable at this time.")
                                .font(Font.footnote.weight(.medium))
                                .foregroundColor(.secondaryLabel)
                            },
                            icon: { Image(systemSymbol: .exclamationmarkTriangleFill)
                                .foregroundColor(.systemYellow)
                            }
                        )
                        .padding(.top, 2)
                    }
                }


            }
            .padding(12)
            .foregroundColor(appPrimary)
            .background(Color.platformBackground)
            .roundedCorners(cornerRadius: 10)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            .padding(.vertical)
        })
    }
}

struct AnnoucementBanner_Previews: PreviewProvider {
    static var previews: some View {
        AnnoucementBanner(viewModel: .mockViewModel)
    }
}
