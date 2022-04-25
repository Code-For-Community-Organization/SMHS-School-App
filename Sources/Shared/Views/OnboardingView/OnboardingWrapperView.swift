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
    @State var stayInPresentation = true
    var contentView: Content
    var body: some View {
        let versionStatus = AppVersionStatus.getVersionStatus()
        let shouldPresent: Binding<Bool> = Binding(get: {
            let shouldShow = versionStatus != .stable || userSettings.developerSettings.alwaysShowOnboarding
            let remoteOverride = Constants.remoteConfig.configValue(forKey: "show_onboarding").boolValue
            return shouldShow && remoteOverride
        },
                                                   set: {_ in
                                                        fatalError("Should not be setting this value.")
                                                   })
        contentView
            .background(
                EmptyView()
                    .sheet(isPresented: shouldPresent.combine(with: $stayInPresentation), content: {
                        OnboardingView(versionStatus: versionStatus, stayInPresentation: $stayInPresentation)
                            .introspectViewController {viewController in
                                viewController.isModalInPresentation = stayInPresentation
                            }
                    }))

    }

}

struct OnboardingWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWrapperView(contentView: EmptyView())
    }
}


