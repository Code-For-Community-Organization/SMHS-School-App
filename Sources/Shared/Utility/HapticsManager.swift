//
//  HapticsManager.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/15/21.
//

import Foundation
import UIKit
import AudioToolbox

struct HapticsManager {
    var notificationFeedbackGenerator: UINotificationFeedbackGenerator? = UINotificationFeedbackGenerator()
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    init(impactStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        notificationFeedbackGenerator?.prepare()
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: impactStyle)
        impactFeedbackGenerator?.prepare()
    }
    mutating func notificationImpact(_ type: UINotificationFeedbackGenerator.FeedbackType){
        notificationFeedbackGenerator?.notificationOccurred(type)
        notificationFeedbackGenerator = nil
    }
    mutating func UIFeedbackImpact() {
        impactFeedbackGenerator?.impactOccurred()
        impactFeedbackGenerator = nil
    }

    func oldSchoolVibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
