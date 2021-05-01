//
//  LoadableView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import SwiftUI

struct LoadableView<Body: View>: View {
    internal init(mainView: Body, headerView: AnyView? = nil, ANDconditions: [Bool], ORconditions: [Bool]) {
        self.mainView = mainView
        self.headerView = headerView
        self.ANDconditions = ANDconditions
        self.ORconditions = ORconditions
    }
    
    @State var loadingViewStyle: LoadingIndicatorView.LoadingProgressStyle = .loading
    var mainView: Body
    var headerView: AnyView?
    var ANDconditions: [Bool]
    var ORconditions: [Bool]
    var shouldShowLoadingView: Bool {
        ANDconditions.allSatisfy({$0}) ||
            ORconditions.allSatisfy({$0})
    }
    var body: some View {
        ZStack {
            if shouldShowLoadingView {
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
            else {
                mainView
            }
            VStack {
                if let header = headerView {
                    header
                }
                Spacer()
            }

        }
        .onAppear{loadingViewStyle = .loading}
    }
}

extension View {
    func loadableView(headerView: AnyView? = nil, ANDconditions: Bool..., ORconditions: Bool..., reload: @escaping () -> Void) -> some View {
        LoadableView(mainView: self, headerView: headerView, ANDconditions: ANDconditions, ORconditions: ORconditions)
            .onAppear{
                reload()
            }
    }
}
