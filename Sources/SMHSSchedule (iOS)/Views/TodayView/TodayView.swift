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
    @StateObject var networkLoadViewModel: NetworkLoadViewModel
    @StateObject var scheduleViewViewModel: SharedScheduleInformation
    @StateObject var todayViewViewModel = TodayViewViewModel()
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View { 
        ZStack(alignment: .top) {
            TodayHeroView(scheduleViewViewModel: scheduleViewViewModel, todayViewViewModel: todayViewViewModel)
                .overlay(
                    Group {
                    if !networkLoadViewModel.isNetworkAvailable &&
                        scheduleViewViewModel.currentDaySchedule == nil &&
                        todayViewViewModel.showNetworkError
                        {
                        InternetErrorView(shouldShowLoading: $networkLoadViewModel.isLoading,
                                          show: $todayViewViewModel.showNetworkError,
                                          reloadData: networkLoadViewModel.reloadDataNow)
                    }
                }
                )
            TodayViewHeader(viewModel: scheduleViewViewModel, todayViewModel: todayViewViewModel)
            
        }
        .sheet(isPresented: $todayViewViewModel.showEditModal){PeriodEditSettingsView(showModal: $todayViewViewModel.showEditModal).environmentObject(userSettings)}
    
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.primary)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.secondary)], for: .normal)
        }
        .onDisappear {
            todayViewViewModel.showNetworkError = true
        }
    }
}


struct TodayViewHeader: View {
    @StateObject var viewModel: SharedScheduleInformation
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
//struct TodayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView(scheduleViewViewModel: SharedScheduleInformation())
//    }
//}
