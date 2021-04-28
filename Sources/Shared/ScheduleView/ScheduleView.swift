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
                        ZStack{
                            ScheduleListView(scheduleViewModel: scheduleViewModel)
                                .transition(.opacity)
                        }
                     
                    }                }
                .platformNavigationBarTitle("\(scheduleViewModel.currentDate)")
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

fileprivate extension View {
    func platformNavigationBarTitle<Content>(_ body: Content) -> some View where Content: StringProtocol {
        #if os(iOS)
            return self.navigationBarTitle(body)
        #elseif os(macOS)
            return self.navigationTitle(body)

        #endif
    }
}
