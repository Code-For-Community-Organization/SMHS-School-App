//
//  InternetErrorView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/3/21.
//

import SwiftUI

struct InternetErrorView: View {
    @Binding var shouldShowLoading: Bool
    @Binding var show: Bool
    var reloadData: () -> ()
    var body: some View {
        VStack {
            if shouldShowLoading {
                LoadingIndicatorView(style: .loading)
            }
            else {
                Image(systemSymbol: .wifiExclamationmark)
                    .imageScale(.large)
                    .padding(.bottom, 5)
                Text("Unable to Connect. Try Again in a Few Minutes.")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .font(.title2, weight: .semibold)
                    .padding(.bottom, 30)
                Button(action: reloadData) {
                    Text("Retry")
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .border(Color.primary, width: 1, cornerRadius: 2, style: .continuous)
                }
                Button(action: {
                    show = false
                }) {
                    Text("IGNORE")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                }
            }

        }
        .font(.callout, weight: .semibold)
        .foregroundColor(.platformSecondaryLabel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.platformBackground.edgesIgnoringSafeArea(.all))
    }
}
