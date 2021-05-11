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
        ZStack {
            Color.platformSecondaryBackground.edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    VStack {
                        #warning("Fix padding for iPad")
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
                    .padding(EdgeInsets(top: 90, leading: 7, bottom: 0, trailing: 7))
                    .padding(.horizontal)
                
                }
                .loadableView(headerView: TodayViewHeader(viewModel: scheduleViewViewModel).typeErased(),
                        ANDconditions: scheduleViewViewModel.currentDaySchedule?.scheduleText == nil,
                        ORconditions: userSettings.developerSettings.alwaysLoadingState,
                        reload: scheduleViewViewModel.reloadData)
                Spacer()
        }
            .onboardingModal()
            .onAppear{
                scheduleViewViewModel.objectWillChange.send()
                if !userSettings.developerSettings.shouldCacheData {
                    scheduleViewViewModel.reset()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct TodayViewHeader: View {
    @StateObject var viewModel: ScheduleViewModel
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
            Image(systemSymbol: .calendar)
                .font(.system(size: 30))
                .foregroundColor(.secondary)

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
