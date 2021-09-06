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
                        Label("Daily Annoucement", systemSymbol: .megaphoneFill)
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
                        if let updateTime = viewModel.lastUpdateTime?.description {
                            Text("Last Updated: \(updateTime)")
                                .font(.caption)
                                .foregroundColor(.secondaryLabel)
                                .padding(.top, 2)
                        }
                        else {
                            Text("Last Updated: Unknown")
                                .font(.caption)
                                .foregroundColor(.secondaryLabel)
                                .padding(.top, 2)
                        }

                    }
                    else {
                        Image(systemSymbol: .exclamationmarkTriangleFill)
                        Text("Daily Annoucement unavailable at this time.")
                    }
                }


            }
            .padding(12)
            .foregroundColor(.appPrimary)
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
