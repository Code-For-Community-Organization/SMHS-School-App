//
//  TodayView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols

struct TodayView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
            VStack{
                VStack {
                    Text("Today's Schedule")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .textAlign(.leading)
                    Text("\(viewModel.currentDate), \(viewModel.subHeaderText)")
                        .titleBold()
                        .textAlign(.leading)
                        .opacity(0.5)

                }
                .padding(.horizontal, 20)
                .padding(.vertical)
                .background(BlurEffectView(style: .regular).edgesIgnoringSafeArea(.all))
                Spacer()
                Group {
                    ClassScheduleView(scheduleText: viewModel.todayScheduleText)
                        .loadableView(ANDconditions: viewModel.todayScheduleText == nil,
                                      ORconditions: userSettings.developerSettings.alwaysLoadingState,
                                      reload: viewModel.loadData)

                    
                }
                .transition(.opacity)

            }
        
        
     
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
