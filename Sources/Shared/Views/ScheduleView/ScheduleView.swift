//
//  ScheduleView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var scheduleViewModel = ScheduleViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State var navigationSelection: Int?
    var body: some View {
        NavigationView {
            VStack{
                HeaderTextView(text: scheduleViewModel.dateHelper.subHeaderText)
                Spacer()
                ScheduleListView(scheduleViewModel: scheduleViewModel)
                    .loadableView(ANDconditions: scheduleViewModel.scheduleWeeks.isEmpty,
                                  ORconditions: userSettings.developerSettings.alwaysLoadingState,
                                  reload: scheduleViewModel.loadData)
            }
            .platformNavigationBarTitle("\(scheduleViewModel.dateHelper.currentDate)")
            .onboardingModal()

        }
        .onAppear{
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewModel.reset()
            }
        }
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleView(scheduleViewModel: mockScheduleView)
    }
    
}
struct HeaderTextView: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .titleBold()
                .textAlign(.leading)
                .opacity(0.5)
                .padding(.horizontal, 20)
        }
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
