//
//  PeriodBlockItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/20/21.
//

import SwiftUI

struct PeriodBlockItem: View {
    @EnvironmentObject var userSettings: UserSettings
    var block: ClassPeriod
    var scheduleTitle: String?
    var twoLine: Bool = false

    var displayedTitle: String {
        if let title = scheduleTitle {
            return title
        }
        else {
            return getTitle(block)
        }
    }

    var className: String? {
        let periodNumber = block.periodNumber
        guard let matchingPeriod = userSettings.editableSettings.filter({$0.periodNumber == periodNumber}).first,
              matchingPeriod.textContent != "" else {
            return nil
        }
        return matchingPeriod.textContent
    }

    var body: some View {
        VStack {
            VStack {
                Group {
                    if twoLine {
                        doubleLineView
                    }
                    else {
                        singleLineView
                            .padding(.bottom, 4)
                    }
                }
                .vibrancyEffectStyle(.tertiaryLabel)

                Spacer()

                if let className = className {
                    Text(className)
                        .fontWeight(.semibold)
                        .textAlign(.leading)
                        .font(.headline)
                        .vibrancyEffectStyle(.label)

                    Text(displayedTitle)
                        .font(.subheadline)
                        .textAlign(.leading)
                        .foregroundColor(.platformSecondaryBackground)
                        .vibrancyEffectStyle(.tertiaryLabel)
                }
                else {
                    Text(displayedTitle)
                        .fontWeight(.medium)
                        .textAlign(.leading)
                        .font(.headline)
                        .vibrancyEffectStyle(.label)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)

        }
        .frame(maxWidth: .infinity)
        .vibrancyEffect()
        .availableBackgroundBlur()
        .roundedCorners(cornerRadius: 10)
        .padding(.vertical, 5)
    }
    
    var doubleLineView: some View {
        VStack {
            Text("START: \(formatDate(block.startTime))")
                .textAlign(.leading)

            Text("END: \(formatDate(block.endTime))")
                .textAlign(.leading)

        }
        .font(Font.caption.weight(.medium))
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
    
    var singleLineView: some View {
        GeometryReader {geo in
            HStack {
                HStack {
                    Text("START:")
                        .vibrancyEffectStyle(.quaternaryLabel)

                    Text(formatDate(block.startTime))
                }
                .frame(width: geo.size.width/CGFloat(2), alignment: .leading)
                HStack {
                    Text("END:")
                        .vibrancyEffectStyle(.quaternaryLabel)

                    Text(formatDate(block.endTime))
                }
                Spacer()
            }
            .font(Font.caption.weight(.medium))
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }

    func getTitle(_ period: ClassPeriod) -> String {
        switch period.periodCategory {
        case .singleLunch:
            return "Nutrition"
        case .period:
            let text = "Period \(String(period.periodNumber ?? -1))"
            return text.autoCapitalized
        default:
            return "\(period.title ?? "Period Block")".autoCapitalized
        }
    }
}

fileprivate extension View {

    @ViewBuilder
    func availableBackgroundBlur() -> some View {
        if #available(iOS 15, *) {
            self.background(.regularMaterial)
        }
        else {
            self
                .background(
                    Color.clear
                    .blurEffect()
                    .blurEffectStyle(.regular)
                )

        }
    }

    @ViewBuilder
    func availablePrimaryVibrancy() -> some View {
        if #available(iOS 15, *) {
            self.foregroundColor(.secondary)
        }
        else {
            self
            .vibrancyEffect()
            .vibrancyEffectStyle(.secondaryLabel)
        }
    }

    @ViewBuilder
    func availableSecondaryVibrancy() -> some View {
        if #available(iOS 15, *) {
            self.foregroundColor(.secondaryLabel)
        }
        else {
            self
            .vibrancyEffect()
            .vibrancyEffectStyle(.tertiaryLabel)
        }
    }
}
