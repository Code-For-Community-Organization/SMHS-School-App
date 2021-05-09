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
    @StateObject var scheduleViewViewModel = ScheduleViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State var selectionMode: NutritionScheduleSelection = .firstLunch
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
                    .padding(.horizontal)
                    
                    ProgressRingView(scheduleDay: scheduleViewViewModel.currentDaySchedule, selectionMode: $selectionMode)
                        .padding(.vertical)
                    Divider()
                        .padding()
                    Text("Detailed Schedule")
                        .fontWeight(.semibold)
                        .font(.title)
                        .textAlign(.leading)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                      
                    ClassScheduleView(scheduleText: scheduleViewViewModel.currentDaySchedule?.scheduleText)
                    Spacer()
                    
                }
                .onboardingModal()
                
                .onAppear{
                    if !userSettings.developerSettings.shouldCacheData {
                        scheduleViewViewModel.reset()
                    }
                }
                .padding(.top, 80)
            }
            TodayViewHeader(viewModel: scheduleViewViewModel)
        }
        .loadableView(headerView: TodayViewHeader(viewModel: scheduleViewViewModel).typeErased(),
                    ANDconditions: scheduleViewViewModel.currentDaySchedule?.scheduleText == nil,
                    ORconditions: userSettings.developerSettings.alwaysLoadingState,
                    reload: scheduleViewViewModel.reloadData)
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
                    .foregroundColor(.platformSecondaryLabel)
                
            }
            Spacer()
            Image(systemSymbol: .calendar)
                .font(.system(size: 30))
                .foregroundColor(.platformTertiaryLabel)

        }
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 10, trailing: 20))
        .background(BlurEffect())
        .edgesIgnoringSafeArea(.all)

    }
}
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
