//
//  ProgressRingView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/7/21.
//

import SwiftUI

struct ProgressRingView: View {
    var scheduleDay: ScheduleDay?
    @Binding var selectionMode: NutritionScheduleSelection
    @State var countDown: TimeInterval?
    @State var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    var body: some View { 
        ZStack {
            Circle()
                .stroke(Color.platformSecondaryBackground, style: .init(lineWidth: 30, lineCap: .round))
                .frame(width: 300, height: 300)
            
            if let percent = scheduleDay?.getCurrentPeriodRemainingPercent(selectionMode: selectionMode) {
                let gradientEndAngle = Angle.degrees((percent * 360.0)-20)
                Circle()
                    .trim(from: 0, to: CGFloat(percent))
                    .stroke(AngularGradient(gradient: .init(colors: [.primary, .secondary]),
                                            center: .center,
                                            startAngle: .degrees(0),
                                            endAngle: gradientEndAngle), style: .init(lineWidth: 30, lineCap: .round))
                    .animation(.easeInOut)
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(-90))
            }
            VStack {
                if let periodNumber = scheduleDay?.getCurrentPeriod(selectionMode: selectionMode)?.periodNumber {
                    Text("PERIOD \(periodNumber)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                else {
                    Text("NUTRITION")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
               if let countDown = countDown, let (hours, minutes, seconds) = countDown.secondsToHoursMinutesSeconds() {
                    Text("\(hours):\(minutes):\(seconds)\nRemaining\n")
                        .multilineTextAlignment(.center)
                }
            }

            
        }
        .onAppear{
            self.countDown = scheduleDay?.getCurrentPeriodRemainingTime(selectionMode: selectionMode)
        }
        .onReceive(timer){_ in
            if countDown != nil, countDown! > 0 {
                self.countDown! -= 1
            }
            else {
                self.countDown = scheduleDay?.getCurrentPeriodRemainingTime(selectionMode: selectionMode)
            }
        }
    }

}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView(scheduleDay: ScheduleDay(id: 1, date: Date(), scheduleText: "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"), selectionMode: .constant(.firstLunch))
    }
}
