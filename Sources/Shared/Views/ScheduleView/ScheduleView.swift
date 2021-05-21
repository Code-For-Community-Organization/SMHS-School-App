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
    @State var presentModal = false
    
    var body: some View {
        NavigationView {
            VStack{
                ScheduleListView(scheduleViewModel: scheduleViewModel, presentModal: $presentModal)
                    .loadableView(ANDconditions: scheduleViewModel.scheduleWeeks.isEmpty,
                                  ORconditions: userSettings.developerSettings.alwaysLoadingState,
                                  reload: scheduleViewModel.reloadData)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .platformNavigationBarTitle("\(scheduleViewModel.dateHelper.todayDateDescription)")
            .navigationBarItems(trailing: HStack {
                Button(systemImage: .infoCircleFill, action: {})
                Button(action: {presentModal = true}, label: Image(systemSymbol: .sliderHorizontal3))
            }
                )

        }
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear{
            scheduleViewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewModel.reset()
            }
        }
        .sheet(isPresented: $presentModal) {CustomScheduleView(scheduleViewModel: scheduleViewModel, showModal: $presentModal)}
    }
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        UIElementPreview(ScheduleView(scheduleViewModel: ScheduleViewModel.mockScheduleView))
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
