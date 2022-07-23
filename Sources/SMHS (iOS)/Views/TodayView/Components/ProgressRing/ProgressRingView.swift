//
//  ProgressRingView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/7/21.
//

import SwiftUI

struct ProgressRingView: View {
    var scheduleDay: ScheduleDay?
    var selectionMode: Binding<PeriodCategory>
    @State var countDown: TimeInterval?
    @State var percent: Double?
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var animation: Bool = true
    init(scheduleDay: ScheduleDay?, selectionMode: Binding<PeriodCategory>, countDown: TimeInterval? = nil, percent: Double? = nil, animation: Bool = true) {
        self.scheduleDay = scheduleDay
        self.selectionMode = selectionMode
        self.countDown = scheduleDay?.getCurrentPeriodRemainingTime(selectionMode: selectionMode.wrappedValue)
        self.percent = scheduleDay?.getCurrentPeriodRemainingPercent(selectionMode: selectionMode.wrappedValue)
        self.animation = animation
    }
    var body: some View {
        VStack {
            Text("See time left in current period.")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.platformSecondaryLabel)
                .padding(.top, 20)
            ZStack {
                Circle()
                    .stroke(Color.platformSecondaryFill,
                            style: .init(lineWidth: CGFloat(30), lineCap: .round))
                    .frame(width: CGFloat(260), height: CGFloat(260))
                
                percentCircle
                ProgressCountDown(scheduleDay: scheduleDay,
                                  selectionMode: selectionMode,
                                  countDown: $countDown)
                
            }
            .onReceive(timer){_ in
                self.countDown = scheduleDay?.getCurrentPeriodRemainingTime(selectionMode: selectionMode.wrappedValue)
                percent = scheduleDay?.getCurrentPeriodRemainingPercent(selectionMode: selectionMode.wrappedValue) ?? 0
            }
            .padding(.top, 15)
            .padding(.bottom, 30)
            
        }
    }
        @ViewBuilder
        var percentCircle: some View {
            if let percent = percent {
                Circle()
                    .trim(from: CGFloat(0) , to: CGFloat(percent))
                    .stroke(AngularGradient(gradient: Gradient.init(colors: [.appPrimary, .appSecondary]),
                                            center: UnitPoint.center,
                                            startAngle: Angle.degrees(0.0),
                                            endAngle: Angle.degrees(percent*360.0)),
                            style: StrokeStyle.init(lineWidth: 30, lineCap: .round))
                    .frame(width: CGFloat(260), height: CGFloat(260))
                    .rotationEffect(Angle.degrees(-90))
                    .animation(animation ? Animation.easeInOut : nil)
            }
            
        }
        
}
    
struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView(scheduleDay: ScheduleDay(date: Date(), scheduleText: "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"), selectionMode: .constant(.firstLunch))
    }
}
