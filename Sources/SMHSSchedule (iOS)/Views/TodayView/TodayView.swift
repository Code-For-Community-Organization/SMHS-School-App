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
    @StateObject var scheduleViewViewModel: ScheduleViewModel
    @StateObject var todayViewViewModel = TodayViewViewModel()
    @EnvironmentObject var userSettings: UserSettings

    
    var body: some View { 
        ZStack(alignment: .top) {
            if scheduleViewViewModel.isNetworkAvailable {
                TodayHeroView(scheduleViewViewModel: scheduleViewViewModel, todayViewViewModel: todayViewViewModel)
            }
            else {
                InternetErrorView(shouldShowLoading: $scheduleViewViewModel.isLoading, reloadData: scheduleViewViewModel.reloadDataNow)
            }
            TodayViewHeader(viewModel: scheduleViewViewModel, todayViewModel: todayViewViewModel)
            
        }
        .sheet(isPresented: $todayViewViewModel.showEditModal){PeriodEditSettingsView(showModal: $todayViewViewModel.showEditModal).environmentObject(userSettings)}
        .onChange(of: scheduleViewViewModel.isNetworkAvailable) {isAvailable in
            if isAvailable {
                scheduleViewViewModel.reloadDataNow()
            }
        }
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.primary)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.secondary)], for: .normal)
        }
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
