//
//  ScheduleView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var scheduleViewModel = ScheduleViewModel()
    @State var navigationSelection: Int?
    var body: some View { 
        ZStack{
            NavigationView {
                VStack{
                    VStack {
                        Text(scheduleViewModel.subHeaderText)
                            .titleBold()
                            .textAlign(.leading)
                            .opacity(0.5)
                    }
                    .padding(.horizontal, 20)
                    if !scheduleViewModel.scheduleWeeks.isEmpty{
                        ScheduleListView(scheduleViewModel: scheduleViewModel)
                            .transition(.opacity)
                    }
                    Spacer()
                }
                
                .navigationBarTitle(Text("\(scheduleViewModel.currentDate)"), displayMode: .automatic)
            }
            if scheduleViewModel.scheduleWeeks.isEmpty {
                ZStack{
                    VStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .transition(.opacity)
                        Text("LOADING")
                            .font(.caption)
                            .fontWeight(.medium)
                            .opacity(0.5)
                            
                    }
                    
                }
            }
            
        }
        
    }
    
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleView(scheduleViewModel: mockScheduleView)
    }
    
}

