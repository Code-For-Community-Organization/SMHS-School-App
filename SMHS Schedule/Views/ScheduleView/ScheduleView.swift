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
        NavigationView {
                VStack{
                    VStack {
                        Text("Daily Schedule")
                            .titleBold()
                            .textAlign(.leading)
                            .opacity(0.5)
                    }
                    .padding(.horizontal)
                    ScheduleListView(scheduleViewModel: scheduleViewModel)
                    Spacer()
                }
            
            .navigationBarTitle(Text("\(scheduleViewModel.currentDate)"), displayMode: .automatic)
        }
        
        
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleView(scheduleViewModel: mockScheduleView)
    }
    
}
