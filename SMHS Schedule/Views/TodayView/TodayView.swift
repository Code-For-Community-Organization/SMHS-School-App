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
            .padding(.top)
            Spacer()
            Group {
                if let scheduleText = viewModel.todayScheduleText {
                    ClassScheduleView(scheduleText: scheduleText)

                }
                else {
                    ClassScheduleView(VStack{
                        Spacer()
                        Image(systemSymbol: .exclamationmarkTriangleFill)
                        Text("Today schedule is unavailable")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    })
                }
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
