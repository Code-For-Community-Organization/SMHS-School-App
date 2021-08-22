//
//  ScheduleView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct ScheduleView: View {
    @StateObject var networkLoadingViewModel: NetworkLoadViewModel
    @StateObject var viewModel: SharedScheduleInformation
    @EnvironmentObject var userSettings: UserSettings
    @State var navigationSelection: Int?
    @State var presentModal = false
    @State var showNetworkError = true
    
    var body: some View {
        NavigationView {
            ScheduleListView(scheduleViewModel: viewModel)
            .edgesIgnoringSafeArea(.bottom)
            .platformNavigationBarTitle("\(viewModel.scheduleNavigationTitle)")
            .onAppear {
                withAnimation {
                    viewModel.scheduleNavigationTitle = viewModel.dateHelper.todayDateDescription
                }
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {presentModal = true}) {
                    Image(systemSymbol: .infoCircleFill)
                        .font(.title3)
                        .imageScale(.large)
                        .padding(5)
                }
                //TODO: Enable slider button after custom schedule fully implemented
                //Button(action: {presentModal = true}, label: Image(systemSymbol: .sliderHorizontal3))
            })
            .overlay(
                Group {
                if !networkLoadingViewModel.isNetworkAvailable &&  //Network disconnected and not available
                    viewModel.scheduleWeeks.isEmpty &&  //No cached schedule weeks to show
                    showNetworkError {  //User have not dismissed the error view
                    InternetErrorView(shouldShowLoading: $networkLoadingViewModel.isLoading,
                                      show: $showNetworkError,
                                      reloadData: networkLoadingViewModel.reloadDataNow)
                }
            }
            )
        }
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear{
            viewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                viewModel.reset()
            }
        }
        .onDisappear {
            showNetworkError = true
        }
        .sheet(isPresented: $presentModal) {SocialDetailView()}
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        UIElementPreview(ScheduleView(networkLoadingViewModel: NetworkLoadViewModel(dataReload: SharedScheduleInformation.mockScheduleView.fetchData), viewModel: SharedScheduleInformation.mockScheduleView))
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
