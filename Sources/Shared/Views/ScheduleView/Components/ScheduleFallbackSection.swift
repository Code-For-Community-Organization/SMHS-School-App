//
//  ScheduleFallbackSection.swift
//  SMHS (iOS)
//
//  Created by Jevon Mao on 12/18/22.
//

import SwiftUI

struct ScheduleFallbackSection: View {
    @State private var showFeedbackAlert = false
    @Binding var userOverrideFallback: Bool
    var alternateColored: Bool
    @State private var feedbackText = ""
    var labelForeground: Color {
        alternateColored ? .platformSecondaryLabel : .white
    }

    var body: some View {
        HStack {
            if userOverrideFallback {
                RevertView(labelForegroundColor: labelForeground,
                           labelAction: {
                    showFeedbackAlert = true
                }, buttonAction: {
                    userOverrideFallback = false
                })
                .availabilityAlertSurvey($showFeedbackAlert, $feedbackText)
            }
            else {
                EnableView(labelForegroundColor: labelForeground) { userOverrideFallback = true }
            }

            Spacer()
        }
        .colorScheme(.dark)
        .if(alternateColored) {view in
            view
                .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .font(.callout.weight(.light))
        .transition(.opacity)
    }
}

fileprivate struct RevertView: View {
    var labelForegroundColor: Color
    var labelAction: () -> Void
    var buttonAction: () -> Void

    var body: some View {
        Button(action: labelAction) {
            Label("Tap to submit feedback.", systemSymbol: .exclamationmarkBubble)
                .padding(.trailing, 10)
                .foregroundColor(labelForegroundColor)
        }

        Button("Revert", systemImage: .arrowUturnLeft) {
            withAnimation {
                buttonAction()
            }
        }
        .foregroundColor(.appPrimary)
        .padding(3)
    }
}

fileprivate struct EnableView: View {
    var labelForegroundColor: Color
    var action: () -> Void

    var body: some View {
        Label("Schedule doesn't look right?", systemSymbol: .exclamationmarkCircle)
            .foregroundColor(labelForegroundColor)

        Button("Tap Here.") {
            withAnimation {
                action()
            }
        }
        .foregroundColor(.appPrimary)
        .padding(3)
    }
}

fileprivate struct AvailabilityAlertSurvey: ViewModifier {
    @Binding var showFeedbackAlert: Bool
    @Binding var feedbackText: String

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .alert("Submit Feedback",
                       isPresented: $showFeedbackAlert,
                       actions: {
                    TextField("Ex. Period 2 class not showing.", text: $feedbackText)
                    Button("Submit", action: {

                    })
                    Button("Cancel", role: .cancel, action: {})
                },
                       message: {
                    Text("Let us know what we can improve on and please include details.")
                })
                .eraseToAnyView()

        }
        else {
            content.eraseToAnyView()
        }
    }
}

fileprivate extension View {
    func availabilityAlertSurvey(_ showFeedbackAlert: Binding<Bool>,
                                 _ feedbackText: Binding<String>) -> some View {
        self.modifier(AvailabilityAlertSurvey(showFeedbackAlert: showFeedbackAlert,
                                              feedbackText: feedbackText))
    }
}
