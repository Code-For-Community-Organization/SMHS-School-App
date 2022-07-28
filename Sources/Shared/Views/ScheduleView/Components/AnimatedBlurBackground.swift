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
            ZStack {
                Image("SM-Field-HiRes")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(1.4, anchor: .bottom)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .if(dynamicBlurred, transform: {
                        $0
                            .blur(radius: 3, opaque: true)
                            .saturation(0.6)
                        
                    }, elseThen: {
                        $0
                            .blurEffect()
                            .blurEffectStyle(.systemMaterial)
                    })

                if dynamicBlurred {
                    Image("SM-Field-HiRes")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.4, anchor: .bottom)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .saturation(0.6)
                        .blur(radius: 60, opaque: true)
                        .mask (
                            LinearGradient(stops: [.init(color: .clear, location: 0),
                                                   .init(color: .clear, location: gradientTopLocation),
                                                   .init(color: .black, location: gradientBottomLocation),
                                                  .init(color: .black, location: 1)], startPoint: .top, endPoint: .bottom)
                        )
                }
            }
        }
        .if(dynamicBlurred) {
            $0
                .drawingGroup()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AnimatedBlurBackground_Previews: PreviewProvider {
    static func configureSettings(legacySchedule: Bool = false) -> UserSettings {
        let settings = UserSettings()
        settings.preferLegacySchedule = legacySchedule
        settings.editableSettings = [.init(periodNumber: 6, textContent: "AP Calculus BC")]
        return settings
    }
    static var previews: some View {
        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
            .environmentObject(UserSettings())

        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
            .environmentObject(configureSettings(legacySchedule: true))
    }
}
