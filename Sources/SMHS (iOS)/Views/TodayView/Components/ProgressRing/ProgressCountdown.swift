//
//  ProgressCountdown.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/11/21.
//

import SwiftUI
import FirebaseCrashlytics

struct ProgressCountDown: View {
    var scheduleDay: ScheduleDay?
    @EnvironmentObject var userSettings: UserSettings
    @Binding var selectionMode: PeriodCategory
    @Binding var countDown: TimeInterval?
    var mockDate: Date?
    var text: String {
        guard let period = scheduleDay?.getCurrentPeriod(selectionMode: selectionMode)
        else {
            let date = Date()
            
            if scheduleDay == nil {
                return "NO SCHOOL 🙌"
            }
            else if let day = scheduleDay {
                if day.isWithinSchoolHours() {
                    return "Passing Period"
                }
                else {
                    return "Schedule Unavailable"
                }
            }
            else {
                let userInfo: [String: Any] = [
                  NSLocalizedDescriptionKey: NSLocalizedString("Failured to find appropriate display text.", comment: ""),
                  NSLocalizedFailureReasonErrorKey: NSLocalizedString("", comment: ""),
                  NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("", comment: ""),
                  "Current time": date.convertToReferenceDateLocalTime(),
                  "Date": date,
                  "View": "\(type(of: self))",
                  "Schedule": scheduleDay?.scheduleText ?? ""
                ]

                let error = NSError.init(domain: NSCocoaErrorDomain,
                                         code: 69,
                                         userInfo: userInfo)

                Crashlytics.crashlytics().record(error: error)
                return "File a bug report to support@smhs.app"
            }
        }

        let customTitle = period.getUserClassName(userSettings: userSettings)
        return customTitle ?? period.getTitle()
    }
    var body: some View {
        VStack {
            
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .frame(maxWidth: 200, maxHeight: 50)
           if let countDown = countDown {
            let (hours, minutes, seconds) = countDown.secondsToHoursMinutesSeconds()
            HStack {
                Text("\(hours)")
                    .fontWeight(.medium)
                Text(":")
                    .fontWeight(.medium)
                    .padding(.horizontal, -4)
                Text("\(minutes)")
                    .fontWeight(.medium)
                Text(":")
                    .fontWeight(.medium)
                    .padding(.horizontal, -4)
                Text("\(seconds)")
                    .fontWeight(.medium)
            }
            .fixedSize()
            .font(.title)
            .availableMonospacedDigit()

            Text("REMAINING")
                .font(.body)
                .foregroundColor(.platformSecondaryLabel)
                .multilineTextAlignment(.center)
            }
        }
        .onAppear{
            self.countDown = scheduleDay?.getCurrentPeriodRemainingTime(selectionMode: selectionMode)
        }
    }
}

struct ProgressCountdown_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCountDown(scheduleDay: ScheduleDay.sampleScheduleDay, selectionMode: .constant(.firstLunch), countDown: .constant(TimeInterval(10)))
        ProgressCountDown(scheduleDay: ScheduleDay.sampleScheduleDay, selectionMode: .constant(.firstLunch), countDown: .constant(TimeInterval(10)))
    }
}

fileprivate extension View {
    func availableMonospacedDigit() -> some View {
        if #available(iOS 15, *) {
            return self
                .monospacedDigit()
                .typeErased()
        }
        else {
            return self.font(Font.system(.title, design: .default))
                .typeErased()
        }
    }
}
