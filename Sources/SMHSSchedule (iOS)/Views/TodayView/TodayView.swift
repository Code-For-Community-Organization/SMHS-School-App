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
        NavigationView {
            VStack {
                TodayViewHeader(viewModel: viewModel)
                ProgressRingView()
                    .padding(.vertical)
                    
                   
                NavigationLink(
                    destination: ClassScheduleView(scheduleText: viewModel.todayScheduleText).padding(.bottom, 50),
                    label: {
                            Text("View today's schedule")
                    })
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
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
}

struct TodayViewHeader: View {
    @StateObject var viewModel: ScheduleViewModel
    var body: some View {
        VStack {
            Text("Today's Schedule")
                .font(.largeTitle)
                .fontWeight(.bold)
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
