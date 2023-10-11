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
        Button(action: {
            if !viewModel.isAnnoucementAvailable {
                viewModel.updateAnnoucements()
            }
            var haptics = HapticsManager(impactStyle: .light)
            viewModel.showAnnoucement = viewModel.isAnnoucementAvailable
            if !viewModel.isAnnoucementAvailable {
                haptics.notificationImpact(.error)
            }
        }, label: {
            VStack {
                HStack(alignment: .top) {
                        Label("Weekly Announcement", systemSymbol: .megaphoneFill)
                            .font(Font.title3.weight(.semibold))
                            .textAlign(.leading)
                            .padding(.bottom, 10)

                        Image(systemSymbol: .chevronRight)
                            .padding(.top, 2)
                            .foregroundColor(.platformSecondaryBackground)

                }

                if viewModel.loadingAnnoucements {
                    ProgressView()
                }
                else {
                    if viewModel.isAnnoucementAvailable {
                        Text("Last Updated: \(viewModel.lastUpdateDisplay)")
                        .font(.caption)
                        .foregroundColor(.platformSecondaryBackground)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    else {
                        Label(
                            title: { Text("Unavailable at this time.")
                                .font(Font.footnote.weight(.medium))
                                .foregroundColor(.platformSecondaryBackground)
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
            .foregroundColor(Color.platformBackground)
            .background(Color.appPrimary)
            .roundedCorners(cornerRadius: 10)
            .padding(.vertical)
        })
            .contextMenu {
                Button("Reload", action: viewModel.fetchAnnoucements)
            }
    }
}

struct AnnoucementBanner_Previews: PreviewProvider {
    static var previews: some View {
        AnnoucementBanner(viewModel: .mockViewModel)
    }
}
