//
//  LoadingIndicatorView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var style: LoadingProgressStyle
    var body: some View {
        if style == .loading {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .transition(.opacity)
                Text("LOADING")
                    .font(.caption)
                    .fontWeight(.medium)
                    .opacity(0.5)
            }
            .animation(.default)
            .transition(.opacity)
        } else if style == .unavailable {
            VStack {
                Image(systemSymbol: .exclamationmarkTriangleFill)
                    .padding(.vertical, 5)
                Text("Today schedule is unavailable")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .animation(.default)
            .transition(.opacity)
        }
    }

    enum LoadingProgressStyle {
        case loading
        case unavailable
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(style: .loading)
        LoadingIndicatorView(style: .unavailable)
    }
}
