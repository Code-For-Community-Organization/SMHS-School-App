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
        Group {
            if style == .loading {
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.bottom, 1)
                    Text("LOADING")
                        .font(.caption)
                        .fontWeight(.medium)
                        .opacity(0.5)
                }
            }
            else if style == .unavailable {
                VStack{
                    Image(systemSymbol: .exclamationmarkTriangleFill)
                        .padding(.bottom, 1)
                    Text("Schedule is unavailable")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .opacity(0.5)
                
            }
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
