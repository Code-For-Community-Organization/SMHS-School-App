//
//  SearchView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI
import SwiftUIX
import VisualEffects
import SwiftUIVisualEffects
import SwiftlySearch

struct SearchView: View {
    @State var searchText: String = ""
    let columns = Array.init(repeating: GridItem(.adaptive(minimum: 200, maximum: 400)), count: 2)
    let informationCards = [InformationCard(title: "Eagle Eats", backgroundColor: Color.systemPink),
                            InformationCard(title: "SMHS Homepage", backgroundColor: Color.systemRed),
                            InformationCard(title: "Athletics", backgroundColor: Color.systemTeal),
                            InformationCard(title: "Directory", backgroundColor: Color.systemGreen)]
    var body: some View {
        NavigationView {
                VStack {
                    ZStack {
                        Image("SMHS-Aerial")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                            .edgesIgnoringSafeArea(.all)
                        
                        LazyVGrid(columns: columns, spacing: 20, content: {
                            ForEach(informationCards, id: \.self){card in
                                ZStack {
                                    Color.clear
                                        .blurEffect()
                                    card.backgroundColor
                                        .opacity(0.5)
                                    Text(card.title)
                                        .fontWeight(.semibold)
                                        .font(.title3)
                                        .frame(alignment: .bottomLeading)
                                        .vibrancyEffect()
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 50)
                                        .multilineTextAlignment(.center)

                                }
                                .vibrancyEffectStyle(.secondaryLabel)
                                .blurEffectStyle(.systemUltraThinMaterial)
                                .roundedCorners(cornerRadius: 10)
                            }
                        })
                        .padding(.horizontal)
                    }
                 
                }
            
            .navigationBarTitle("Search")
            .navigationBarSearch($searchText, placeholder: "Schedules, news, SMHS website, and More", hidesNavigationBarDuringPresentation: false, hidesSearchBarWhenScrolling: false, cancelClicked: {}, searchClicked: {})
        }
        .navigationViewStyle(StackNavigationViewStyle())
        

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
