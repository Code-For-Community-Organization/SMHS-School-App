//
//  InformationCardItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI

struct InformationCardItem: View {
    @Environment(\.colorScheme) var colorScheme
    var card: InformationCard
    
    var body: some View {
            ZStack {
                card.image
                    .resizable()
                    .saturation(0)
                    .aspectRatio(1.4, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                Color.clear.blurEffect().opacity(0.9)
                LinearGradient(gradient: Gradient(colors: [card.backgroundColor.opacity(0.3), card.backgroundColor]), startPoint: .leading, endPoint: .trailing)
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                Text(card.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.7)
                    .lineLimit(card.lineLimit)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .adaptableTitleColor(colorScheme)
            }
            .blurEffectStyle(.systemUltraThinMaterial)
            .roundedCorners(cornerRadius: 10)
            .vibrancyEffectStyle(.secondaryLabel)
            .shadow(color: card.backgroundColor.opacity(0.3), radius: 8, x: 4, y: 4)
            .padding(.horizontal, 5)
        
    }
}

struct InformationCardItem_Previews: PreviewProvider {
    static var previews: some View {
        InformationCardItem(card: InformationCard.informationCards.first!)
    }
}

fileprivate extension View {
    
    @ViewBuilder
    func adaptableTitleColor(_ colorScheme: ColorScheme) -> some View {
        if colorScheme == .light {
            self.foregroundColor(.platformBackground)
        }
        else {self.vibrancyEffect()}
    }
}
