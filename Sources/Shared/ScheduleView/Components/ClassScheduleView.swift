//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols

struct ClassScheduleView: View {
    var scheduleText: String?
    var contentView: AnyView?
    init(scheduleText: String){
        self.scheduleText = scheduleText
    }
    init<Content: View>(_ view: Content) {
        self.contentView = AnyView(view)
    }
    var body: some View {
        VStack{
            ScrollView {
                Group{
                    if let text = scheduleText {
                        #warning("FIXME - Color platfrom adapt")
                        Text(text)
                            .foregroundColor(.platformLabel)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                    }
                    else if let contentView = contentView {
                        contentView
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.platformBackground)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .edgesIgnoringSafeArea(.all)
        .offset(y: 20)
    }

}

struct ScheduleCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClassScheduleView(scheduleText: "Special Virtual Schedule Day 2\nWednesday, April 21 \nSpecial Virtual Day 2 \n(40 minute classes) \n\nPeriod 2                         8:00-8:40 \n\nPeriod 3                         8:45-9:25 \n(10 minute break) \n\nPeriod 4                         9:35-10:15 \n\nPeriod 5                         10:20-11:40 \n(40 minute DIVE Presentation) \n\nNutrition                      11:40-12:10 \n\nPeriod 6                         12:15-12:55 \n\nPeriod 7                         1:00-1:40 \n\nPeriod 1                         1:45-2:25 \n-------------------------------\n\n\nClasses 8:00-2:25\n\nDive Presentation\n\nB JV Tennis vs JSerra 5:30\n\nB JV/V LAX vs JSerra 7:30/5:30\n\nB JV/V Vball vs Bosco 3:00/3:00\n\nB V Basketball vs Bosco 7:00\n\nB V Golf @ Hunt Beach 3:00\n\nG JV Tennis vs Orange Luth 3:15\n\nG V LAX @ JSerra 5:30\n\nG V Tennis @ Orange Luth 2:30\n\nJV Gold Baseball vs JSerra 3:30\n\nJV/V Baseball @ South Hills 2:30/3:15\n\n\n\nV Sball vs Mission Viejo 3:30\n")
        ClassScheduleView(VStack{
            Spacer()
            Image(systemSymbol: .exclamationmarkTriangleFill)
            Text("Today's schedule is unavailable")
                .font(.body)
                .fontWeight(.medium)
            Spacer()

        })
    }
}
