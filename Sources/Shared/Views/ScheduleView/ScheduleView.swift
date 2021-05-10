//
//  ScheduleView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct ScheduleView: View {
    @StateObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var userSettings: UserSettings
    @State var navigationSelection: Int?
    var body: some View {
        NavigationView {
            VStack{
                ScheduleListView(scheduleViewModel: scheduleViewModel)
                    .loadableView(ANDconditions: scheduleViewModel.scheduleWeeks.isEmpty,
                                  ORconditions: userSettings.developerSettings.alwaysLoadingState,
                                  reload: scheduleViewModel.reloadData)
                Spacer()
            }
            .platformNavigationBarTitle("\(scheduleViewModel.dateHelper.currentDate)")

        }
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear{
            scheduleViewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewModel.reset()
            }
        }
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        UIElementPreview(ScheduleView(scheduleViewModel: ScheduleViewModel.mockScheduleView))
    }
    
}
struct HeaderTextView: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .fontWeight(.semibold)
                .font(.title2)
                .textAlign(.leading)
                .vibrancyEffect()
        }
        .padding(EdgeInsets(top: 45, leading: 20, bottom: 10, trailing: 20))
        .background(BlurEffect())
        .vibrancyEffectStyle(.secondaryLabel)
        .blurEffectStyle(.systemThinMaterial)
    }
}
fileprivate extension View {
    func platformNavigationBarTitle<Content>(_ body: Content) -> some View where Content: StringProtocol {
        #if os(iOS)
        return self.navigationBarTitle(body)
        #elseif os(macOS)
        return self.navigationTitle(body)
        
        #endif
    }
}
