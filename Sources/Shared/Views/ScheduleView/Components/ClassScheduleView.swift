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
                LazyVStack(spacing: 10) {
                    ForEach(scheduleDay?.periods ?? [], id: \.self){day in
                        VStack(spacing: 5) {
                            VStack {
                                HStack(spacing: 20) {
                                    HStack {
                                        Text("START:")
                                            .fontWeight(.medium)
                                            .opacity(0.5)
                                        Text(formatDate(day.startTime))
                                            .fontWeight(.medium)
                                    }
                                    HStack {
                                        HStack {
                                            Text("END:")
                                                .fontWeight(.medium)
                                                .opacity(0.5)
                                            Text(formatDate(day.endTime))
                                                .fontWeight(.medium)
                                        }
                                    }
                                    Spacer()
                                }
                                .font(.footnote)
                                //.padding(.top, 0.2)
                                Spacer()
                                    if let period = day.periodNumber {
                                        Text( "Period \(String(period))")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .textAlign(.leading)
                                            //.padding(.bottom, 0.2)
                                    }
                                    else {
                                        Text("Nutrition")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .textAlign(.leading)
                                            //.padding(.bottom, 0.2)
                                    }
                                
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .foregroundColor(.platformTertiaryBackground)
     
                        }
                        .frame(maxWidth: .infinity)
                        .background(.primary)
                        .roundedCorners(cornerRadius: 15)

                    }
                }
                .padding(.horizontal)
            }.navigationBarTitleDisplayMode(.inline)


       
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }

}

//struct ScheduleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIElementPreview(ClassScheduleView.previewClassScheduleView)
//    }
//}
