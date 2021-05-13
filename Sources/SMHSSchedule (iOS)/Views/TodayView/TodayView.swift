//
//  TodayView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols
import SwiftUIVisualEffects

struct TodayView: View {
    @ObservedObject var scheduleViewViewModel: ScheduleViewModel
    @StateObject var todayViewViewModel = TodayViewViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State var selectionMode: NutritionScheduleSelection
    init(scheduleViewViewModel: ScheduleViewModel, selectionMode: NutritionScheduleSelection? = nil) {
        self.selectionMode = selectionMode ?? .firstLunch
        self.scheduleViewViewModel = scheduleViewViewModel
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.primary)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.secondary)], for: .normal)
    }
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                    VStack {
                        Picker("", selection: $selectionMode){
                            Text("1st Lunch")
                                .tag(NutritionScheduleSelection.firstLunch)
                            Text("2nd Lunch")
                                .tag(NutritionScheduleSelection.secondLunch)
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        ProgressRingView(scheduleDay: scheduleViewViewModel.currentDaySchedule, selectionMode: $selectionMode)
                            .padding(.vertical, 10)
                        Divider()
                        Text("Detailed Schedule")
                            .fontWeight(.semibold)
                            .font(.title2)
                            .textAlign(.leading)
                            .padding(.bottom, 5)
                        ScheduleViewTextLines(scheduleLines: scheduleViewViewModel.currentDaySchedule?.scheduleText.lines, lineSpacing: 2)
                    }
                    .padding(EdgeInsets(top: 110, leading: 7, bottom: 0, trailing: 7))
                    .padding(.horizontal)
                
                }
                .loadableView(
                        ANDconditions: scheduleViewViewModel.currentDaySchedule?.scheduleText == nil,
                        ORconditions: userSettings.developerSettings.alwaysLoadingState,
                        reload: scheduleViewViewModel.reloadData)
                .onboardingModal()
                .onAppear{
                    scheduleViewViewModel.objectWillChange.send()
                    if !userSettings.developerSettings.shouldCacheData {
                        scheduleViewViewModel.reset()
                    }
            }
            
            TodayViewHeader(viewModel: scheduleViewViewModel, todayViewModel: todayViewViewModel) 

        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $todayViewViewModel.showEditModal, content: {PeriodEditSettingsView(showModal: $todayViewViewModel.showEditModal)        .environmentObject(userSettings)
})
    }
}


struct TodayViewHeader: View {
    @StateObject var viewModel: ScheduleViewModel
    @StateObject var todayViewModel: TodayViewViewModel
    var body: some View {
        HStack {
            VStack {
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .textAlign(.leading)
                Text(viewModel.dateHelper.currentDate)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .textAlign(.leading)
                    .vibrancyEffect()
                    //.foregroundColor(.platformSecondaryLabel)
                
            }
            Spacer()
            Button(action: {todayViewModel.showEditModal = true}, label: {
                Image(systemSymbol: .ellipsisCircle)
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
            })
        }
        .padding(EdgeInsets(top: 45, leading: 20, bottom: 10, trailing: 20))
        .vibrancyEffectStyle(.secondaryLabel)
        .background(BlurEffect())
        .blurEffectStyle(.systemThinMaterial)
        .edgesIgnoringSafeArea(.all)

    }
}
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(scheduleViewViewModel: ScheduleViewModel())
    }
}
