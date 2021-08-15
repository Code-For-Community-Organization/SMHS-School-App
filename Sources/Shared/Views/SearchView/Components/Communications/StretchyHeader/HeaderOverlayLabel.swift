//
//  HeaderOverlayLabel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/31/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct HeaderOverlayLabel: View {
    @State var geo: GeometryProxy
    var stretchy: Bool
    var body: some View {
        VStack {
            Spacer()
            if stretchy {
                _body
                    .offset(x: CGFloat(0), y: SMStretchyHeader.getOffsetForHeaderImage(geo) + CGFloat(20))
            } else {
                _body
            }
        }
    }

    // Conditionally apply offset modifier
    var _body: some View {
        HStack {
            Image("Logo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 40)
                .padding(.leading)
            VStack {
                Text("Santa Margarita Catholic High School")
                    .font(.system(.title2, design: .default))
                    .fontWeight(.bold)
                    .textAlign(.leading)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, -3)
                Text("The #1 Catholic Coed High School in Southern California.")
                    .font(.caption, weight: .medium)
                    .textAlign(.leading)
                    .multilineTextAlignment(.leading)
                    .opacity(0.8)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BlurEffect())
        .blurEffectStyle(.systemChromeMaterialDark)
    }
}

// struct HeaderOverlayLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderOverlayLabel()
//    }
// }
