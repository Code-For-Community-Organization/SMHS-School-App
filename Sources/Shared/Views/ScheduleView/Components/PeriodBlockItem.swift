//
//  PeriodBlockItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/20/21.
//

import SwiftUI

struct PeriodBlockItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSettings: UserSettings
    var block: ClassPeriod
    var twoLine: Bool = false
    var isBlurred = true
    var displayedTitle: String {
        let title =  block.getTitle()
        // Map from API fetched period names to better, readable names
        // Configurable from Firebase remotely to adapt for changes
        let periods = Constants.Schedule.periodMappings
        return periods[title
            .lowercased()
            .trimmingCharacters(in: .whitespaces)] ?? title

    }

    var body: some View {
        VStack {
            VStack {
                Group {
                    doubleLineView
                        .padding(.bottom, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .vibrancyEffectStyle(.tertiaryLabel)

                Spacer()

                if let className = block.getUserClassName(userSettings: userSettings) {
                    Text(className)
                        .fontWeight(.semibold)
                        .textAlign(.leading)
                        .font(.headline)
                        .lineLimit(nil)
                        .allowsTightening(true)
                        //.minimumScaleFactor(0.8)
                        .if(isBlurred) {
                            $0.vibrancyEffectStyle(.label)
                        }

                    HStack {
                        Text(displayedTitle)
                            .font(.subheadline)
                            .textAlign(.leading)
                            .foregroundColor(.platformSecondaryBackground)
                            .if(isBlurred) {
                                $0.vibrancyEffectStyle(.tertiaryLabel)
                            }
                        Spacer()
                        if let room = block.getUserRoom(userSettings: userSettings) {
                            Text(twoLine ? room.rawValue : "Room: \(room.rawValue)")
                                .font(.subheadline, weight: .semibold)
                                .textAlign(.trailing)
                                .foregroundColor(.platformSecondaryBackground)
                                .if(isBlurred) {
                                    $0.vibrancyEffectStyle(.tertiaryLabel)
                                }
                        }
                    }

                }
                else {
                    Text(displayedTitle)
                        .fontWeight(.semibold)
                        .textAlign(.leading)
                        .font(.headline)
                        .lineLimit(1)
                        .if(isBlurred) {
                            $0.vibrancyEffectStyle(.label)
                        }
                    if twoLine {
                        Text("")
                            .fontWeight(.semibold)
                            .textAlign(.leading)
                            .font(.headline)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .if(!isBlurred) {
                $0.foregroundColor(.platformTertiaryBackground)
            }

        }
        .frame(maxWidth: .infinity)
        .if(isBlurred, transform: {
            $0
                .vibrancyEffect()
                .availableBackgroundBlur(colorScheme: colorScheme, isBlurred: isBlurred)
        }, elseThen: {
            $0
                .background(Color.appPrimary)
        })

            .roundedCorners(cornerRadius: 10)
            .padding(.vertical, 5)
    }
    
    var doubleLineView: some View {
        HStack {
            Text("\(formatDate(block.startTime))")
            Image(systemSymbol: .arrowRightSquare)
            Text("\(formatDate(block.endTime))")
        }
        .lineLimit(1)
        .minimumScaleFactor(0.1)
        .allowsTightening(true)
        .font(Font.caption.weight(.medium))
    }

    var singleLineView: some View {
        GeometryReader {geo in
            HStack {
                HStack {
                    Text("START:")
                        .if(isBlurred, transform: {
                            $0
                                .vibrancyEffectStyle(.quaternaryLabel)
                        }, elseThen: {
                            $0
                                .opacity(0.5)
                        })


                            Text(formatDate(block.startTime))
                }
                .frame(width: geo.size.width/CGFloat(2), alignment: .leading)
                HStack {
                    Text("END:")
                        .if(isBlurred, transform: {
                            $0
                                .vibrancyEffectStyle(.quaternaryLabel)
                        }, elseThen: {
                            $0
                                .opacity(0.5)
                        })

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
}

fileprivate extension View {

    @ViewBuilder
    func availableBackgroundBlur(colorScheme: ColorScheme,
                                 isBlurred: Bool = true) -> some View {
        if isBlurred {
            if #available(iOS 15, *) {
                self.background(.regularMaterial)
            }
            else {
                self
                    .background(
                        Color.clear
                            .blurEffect()
                            .blurEffectStyle(.regular)
//                            .if(colorScheme == .light, transform: {
//                                $0
//                                    .blurEffectStyle(.systemMaterialLight)
//
//                            }, elseThen: {
//                                $0
//                                    .blurEffectStyle(.systemMaterialDark)
//                                }
//                               )
                    )
            }
        }
        else {
            self.background(Color.appPrimary)
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

struct PeriodBlockItem_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDetailView()
    }
}

