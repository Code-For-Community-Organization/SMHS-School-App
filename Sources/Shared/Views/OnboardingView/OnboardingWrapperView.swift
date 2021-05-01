//
//  OnboardingView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI
import Introspect

struct OnboardingWrapperView<Content: View>: View {
    @EnvironmentObject var userSettings: UserSettings
    @StateObject var viewModel: OnboardingWrapperViewModel = OnboardingWrapperViewModel()
    var contentView: Content
    var body: some View {
        let shouldPresent: Binding<Bool> = Binding(get: {viewModel.versionStatus != .stable || userSettings.developerSettings.alwaysShowOnboarding},
                                                   set: {_ in
                                                        fatalError("Should not be setting this value.")
                                                   })
        contentView
            .sheet(isPresented: shouldPresent.combine(with: $viewModel.stayInPresentation), content: {
                OnboardingView(versionStatus: viewModel.versionStatus, stayInPresentation: $viewModel.stayInPresentation)
                    .introspectViewController{viewController in
                        viewController.isModalInPresentation = viewModel.stayInPresentation
                    }
            })
    }

}

struct OnboardingWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWrapperView(contentView: EmptyView())
    }
}


