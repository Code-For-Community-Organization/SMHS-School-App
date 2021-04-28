//
//  LoadableView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import SwiftUI

struct LoadableView<Body: View>: View {
    @State var loadingViewStyle: LoadingIndicatorView.LoadingProgressStyle = .loading
    var mainView: Body
    var ANDconditions: [Bool]
    var ORconditions: [Bool]
    var shouldShowLoadingView: Bool {
        ANDconditions.allSatisfy({$0}) ||
            ORconditions.allSatisfy({$0})
    }
    var body: some View {
            if shouldShowLoadingView {
                ZStack {
                    VStack {
                        LoadingIndicatorView(style: loadingViewStyle)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                    if shouldShowLoadingView {
                                        loadingViewStyle = .unavailable
                                    }
                                }
                            }
                    }
         
                }
                .zIndex(10)
                }
                else {
                    mainView
                }
        }
}

extension View {
    func loadableView(ANDconditions: Bool..., ORconditions: Bool..., reload: @escaping () -> Void) -> some View {
        LoadableView(mainView: self, ANDconditions: ANDconditions, ORconditions: ORconditions)
            .onAppear{
                reload()
            }
    }
}
