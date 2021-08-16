//
//  TodayView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import PermissionsSwiftUINotification
import SFSafeSymbols
import SwiftUI
import SwiftUIVisualEffects

struct TodayView: View {
    @StateObject var networkLoadViewModel: NetworkLoadViewModel
    @StateObject var scheduleViewViewModel: SharedScheduleInformation
    @StateObject var todayViewViewModel = TodayViewViewModel()
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack(alignment: .top) {
            TodayHeroView(scheduleViewViewModel: scheduleViewViewModel,
                          todayViewViewModel: todayViewViewModel)
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
            TodayViewHeader(viewModel: scheduleViewViewModel,
                            todayViewModel: todayViewViewModel)
        }
        .sheet(isPresented: $todayViewViewModel.showEditModal) {
            PeriodEditSettingsView(showModal: $todayViewViewModel.showEditModal)
                .environmentObject(userSettings)
        }

        .onAppear {
            todayViewViewModel.showPermission = true
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.primary)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.secondary)], for: .normal)
        }
        .onDisappear {
            todayViewViewModel.showNetworkError = true
        }
        .JMAlert(showModal: $todayViewViewModel.showPermission,
                 for: [.notification])
    }
}

struct TodayViewHeader: View {
    @StateObject var viewModel: SharedScheduleInformation
    @StateObject var todayViewModel: TodayViewViewModel
    var body: some View {
        HStack {
            VStack {
                Text(viewModel.dateHelper.todayDateDescription)
                    .fontWeight(.semibold)
                    .textAlign(.leading)
                    .textCase(.uppercase)
                    .vibrancyEffect()

                Text(viewModel.dateHelper.currentWeekday)
                    .font(.title)
                    .fontWeight(.bold)
                    .textAlign(.leading)
                // .foregroundColor(.platformSecondaryLabel)
            }
            Button(action: { todayViewModel.showEditModal = true }, label: {
                HStack {
                    Image(systemSymbol: .pencil)
                        .font(Font.subheadline.weight(.semibold))
                        .imageScale(.large)
                        .padding(.trailing, -1)

                    Text("Edit")
                        .font(Font.subheadline.weight(.semibold))
                }
                .foregroundColor(.secondary)
            })
        }
        .padding(EdgeInsets(top: -3, leading: 20, bottom: 7, trailing: 20))
        .vibrancyEffectStyle(.secondaryLabel)
        .background(BlurEffect().edgesIgnoringSafeArea(.all))
        .blurEffectStyle(.systemThinMaterial)
    }
}

// struct TodayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView(scheduleViewViewModel: SharedScheduleInformation())
//    }
// }
