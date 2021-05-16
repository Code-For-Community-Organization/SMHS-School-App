//
//  InformationCardsView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct InformationCardsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showWebView = false
    @State private var informationCard: InformationCard?
    let columns = Array.init(repeating: GridItem(.adaptive(minimum: 180)), count: 1)
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 30, content: {
                        ForEach(InformationCard.informationCards){card in
                            Button(action: {informationCard = card; showWebView = true}, label: {
                                ZStack {
                                    card.image
                                        .resizable()
                                        .scaledToFill()
                                        .saturation(0)
                                        .frame(width: 180, height: 130)
                                    Color.clear.blurEffect().opacity(0.9)
                                    LinearGradient(gradient: Gradient(colors: [card.backgroundColor.opacity(0.3), card.backgroundColor]), startPoint: .leading, endPoint: .trailing)
                                        .opacity(0.5)
                                        .edgesIgnoringSafeArea(.all)
                                    Text(card.title)
                                        .fontWeight(.bold)
                                        .font(.title3)
                                        .multilineTextAlignment(.center)
                                        .minimumScaleFactor(0.85)
                                        .padding(.horizontal)
                                        .adaptableTitleColor(colorScheme)
                                    
                                }
                                .blurEffectStyle(.systemUltraThinMaterial)
                                .roundedCorners(cornerRadius: 10)
                                .vibrancyEffectStyle(.secondaryLabel)
                                .shadow(color: card.backgroundColor.opacity(0.3), radius: 8, x: 4, y: 4)
                            })
                            .onAppear{
                                print("\(card)")
                            }

                        }
                    })
                    .padding(.horizontal)
                    .padding(.top, 30)
                }
    
                
            }
        }
        .navigationBarTitle("Search")
        .introspectNavigationController{
            $0.navigationBar.titleTextAttributes = [.foregroundColor : UIColor(Color.primary)]
            $0.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor(Color.primary)]
        }
        .fullScreenCover(item: $informationCard){
            SafariView(url: $0.link).edgesIgnoringSafeArea(.all)
        }
    }
    
}

struct InformationCardsView_Previews: PreviewProvider {
    static var previews: some View {
        InformationCardsView()
    }
}

fileprivate extension View {
    func adaptableTitleColor(_ colorScheme: ColorScheme) -> AnyView {
        if colorScheme == .light {
            return self.foregroundColor(.platformBackground).typeErased()
        }
        else {return self.vibrancyEffect().typeErased()}
    }
}
