//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols

struct ClassScheduleView: View {
    var scheduleDay: ScheduleDay?
    var body: some View {
            ScrollView {
                LazyVStack {
                    ForEach(scheduleDay?.periods ?? [], id: \.self){day in
                        VStack(spacing: 5) {
                            VStack {
                                HStack(spacing: 20) {
                                    Text("START: \(formatDate(day.startTime))")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Text("END: \(formatDate(day.endTime))")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                    if let period = day.periodNumber {
                                        Text( "Period \(String(period))")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .textAlign(.leading)
                                    }
                                    else {
                                        Text("Nutrition")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .textAlign(.leading)
                                    }
                                
                            }
                            .padding()
     
                        }
                        .frame(maxWidth: .infinity)
                        .background(.platformSecondaryBackground)
                        .padding(.vertical, 3)
                        .roundedCorners(cornerRadius: 20)

                    }
                }
                .padding(.horizontal)
            }.navigationBarTitleDisplayMode(.inline)


       
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

}

//struct ScheduleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIElementPreview(ClassScheduleView.previewClassScheduleView)
//    }
//}
