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
    @StateObject var viewModel = ScheduleViewModel()
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        VStack{
            TodayViewHeader(viewModel: viewModel)
            ClassScheduleView(scheduleText: viewModel.todayScheduleText)
                .padding(.bottom, 50)
            Spacer()
            
        }
        .onboardingModal()
        .loadableView(headerView: TodayViewHeader(viewModel: viewModel).typeErased(),
                      ANDconditions: viewModel.todayScheduleText == nil,
                      ORconditions: userSettings.developerSettings.alwaysLoadingState,
                      reload: viewModel.reloadData)
        
        .onAppear{
            if !userSettings.developerSettings.shouldCacheData {
                viewModel.reset()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct TodayViewHeader: View {
    @StateObject var viewModel: ScheduleViewModel
    var body: some View {
        VStack {
            Text("Today's Schedule")
                .font(.largeTitle)
                .fontWeight(.black)
                .textAlign(.leading)
            Text("\(viewModel.dateHelper.currentDate), \(viewModel.dateHelper.subHeaderText)")
                .titleBold()
                .textAlign(.leading)
                .opacity(0.5)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
        .background(BlurEffect().edgesIgnoringSafeArea(.all))
    }
}
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
