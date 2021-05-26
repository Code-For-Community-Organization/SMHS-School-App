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
    var selectionMode: PeriodCategory
    init(scheduleViewViewModel: ScheduleViewModel, selectionMode: PeriodCategory? = nil) {
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
                    Picker("", selection: $todayViewViewModel.selectionMode){
                        Text("1st Lunch")
                            .tag(PeriodCategory.firstLunch)
                        Text("2nd Lunch")
                            .tag(PeriodCategory.secondLunch)
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    ProgressRingView(scheduleDay: scheduleViewViewModel.currentDaySchedule, selectionMode: $todayViewViewModel.selectionMode)
                        .padding(.vertical, 10)
                    Text("Detailed Schedule")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .textAlign(.leading)
                        .padding(.bottom, 10)
                    ScheduleDetailView(scheduleDay: scheduleViewViewModel.currentDaySchedule)
                }
                .padding(EdgeInsets(top: 110, leading: 7, bottom: 0, trailing: 7))
                .padding(.horizontal)
            }
            .background(Color.platformBackground)
            .loadableView(
                ANDconditions: scheduleViewViewModel.currentDaySchedule?.scheduleText == nil,
                ORconditions: userSettings.developerSettings.alwaysLoadingState,
                reload: scheduleViewViewModel.reloadData)
            .onboardingModal()
            .onAppear{
                todayViewViewModel.selectionMode = selectionMode
                scheduleViewViewModel.objectWillChange.send()
                if !userSettings.developerSettings.shouldCacheData {
                    scheduleViewViewModel.reset()
                }
            }
            .aboutFooter()
            
            TodayViewHeader(viewModel: scheduleViewViewModel, todayViewModel: todayViewViewModel) 
            
        }
        .sheet(isPresented: $todayViewViewModel.showEditModal){PeriodEditSettingsView(showModal: $todayViewViewModel.showEditModal).environmentObject(userSettings)}
    }
}


struct TodayViewHeader: View {
    @StateObject var viewModel: ScheduleViewModel
    @StateObject var todayViewModel: TodayViewViewModel
    var body: some View {
        HStack {
            VStack {
                Text(viewModel.dateHelper.currentWeekday)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .textAlign(.leading)
                Text(viewModel.dateHelper.todayDateDescription)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .textAlign(.leading)
                    .vibrancyEffect()
                //.foregroundColor(.platformSecondaryLabel)
                
            }
            Spacer()
            Button(action: {todayViewModel.showEditModal = true}, label: {
                Image(systemSymbol: .ellipsisCircle)
                    .font(.title3)
                    .imageScale(.large)
                    .padding(5)
                    .foregroundColor(.secondary)
            })
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
        .vibrancyEffectStyle(.secondaryLabel)
        .background(BlurEffect().edgesIgnoringSafeArea(.all))
        .blurEffectStyle(.systemThinMaterial)
        
    }
}
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(scheduleViewViewModel: ScheduleViewModel())
    }
}
