//
//  AnimatedBlurBackground.swift
//  SMHS (iOS)
//
//  Created by Jevon Mao on 7/25/22.
//

import SwiftUI

struct AnimatedBlurBackground: View {
    @Binding var bottomTextScreenRatio: Double

    var gradientTopLocation: CGFloat {
        return bottomTextScreenRatio - 0.05.clamped(to: 0...1)
    }

    var gradientBottomLocation: CGFloat {
        return bottomTextScreenRatio + 0.05.clamped(to: 0...1)
    }
    var dynamicBlurred: Bool

    var body: some View {
        GeometryReader {geo in
            if true {
                makeBackgroundImage(geo)
                    .blurEffect()
                    .blurEffectStyle(.systemUltraThinMaterial)
            }
            else {
//                ZStack {
//                    makeBackgroundImage(geo)
//                        .if(dynamicBlurred, transform: {
//                            $0
//                                .blur(radius: 2, opaque: true)
//
//                        }, elseThen: {
//                            $0
//                                .blurEffect()
//                                .blurEffectStyle(.systemMaterial)
//                        })
//
//                    if dynamicBlurred {
//                        makeBackgroundImage(geo)
//                            .blur(radius: 60, opaque: true)
//                            .mask (
//                                LinearGradient(stops: [.init(color: .clear, location: 0),
//                                                       .init(color: .clear, location: gradientTopLocation),
//                                                       .init(color: .black, location: gradientBottomLocation),
//                                                      .init(color: .black, location: 1)], startPoint: .top, endPoint: .bottom)
//                            )
//                    }
//                }
//                .if(dynamicBlurred) {
//                    $0
//                        .drawingGroup()
//                }
            }

        }

        .edgesIgnoringSafeArea(.all)
    }

    func makeBackgroundImage(_ geo: GeometryProxy) -> some View {
        Image("SM-Field-HiRes")
            .resizable()
            .scaledToFill()
            //.scaleEffect(1.4, anchor: .bottom)

            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .brightness(-0.1)
    }
}

struct AnimatedBlurBackground_Previews: PreviewProvider {
    static func configureSettings(legacySchedule: Bool = false) -> UserSettings {
        let settings = UserSettings()
        settings.preferLegacySchedule = legacySchedule
        //settings.editableSettings = [.init(periodNumber: 6, subject: "AP Calculus BC", room: .g301)]
        return settings
    }
    static var previews: some View {
        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
            .environmentObject(configureSettings(legacySchedule: false))

        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
            .environmentObject(configureSettings(legacySchedule: true))
    }
}
