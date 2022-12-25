//
//  ScheduleFallbackSection.swift
//  SMHS (iOS)
//
//  Created by Jevon Mao on 12/18/22.
//

import SwiftUI
import SwiftUIVisualEffects
import FirebaseCrashlytics

struct ScheduleFallbackSection: View {
    @State private var showFeedbackAlert = false
    @Binding var userOverrideFallback: Bool
    var alternateColored: Bool
    @State private var feedbackText = ""

    var body: some View {
        HStack {
            if userOverrideFallback {
                RevertView(alternateColored: alternateColored,
                           labelAction: {
                    showFeedbackAlert = true
                }, buttonAction: {
                    userOverrideFallback = false
                })
                .availabilityAlertSurvey($showFeedbackAlert, $feedbackText, action: submitResponse)
            }
            else {
                EnableView(alternateColored: alternateColored)
                { userOverrideFallback = true }
            }

            Spacer()
        }
        // No extra padding needed for today view
        .if(!alternateColored) {view in
            view
                .padding(.horizontal)
                .padding(.vertical, 10)

        }
        .padding(.bottom)
        .font(.callout.weight(.light))
        .transition(.opacity)
    }

    private func submitResponse() {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString(Constants.Errors.scheduleUserFeedbackDescription,
                                                         comment: ""),
            "View": "\(ScheduleFallbackSection.self)"
        ]

        let error = NSError.init(domain: NSCocoaErrorDomain,
                                 code: Constants.Errors.scheduleUserFeedbackCode,
                                 userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
        feedbackText = ""
    }
}

fileprivate struct RevertView: View {
    var alternateColored: Bool
    var labelAction: () -> Void
    var buttonAction: () -> Void

    var body: some View {
        Button(action: labelAction) {
            Label("Tap to submit feedback.", systemSymbol: .exclamationmarkBubble)
                .padding(.trailing, 10)
                .if(alternateColored, transform: {view in
                    view
                        .foregroundColor(.secondaryLabel)
                }, elseThen: {view in
                    view
                        .vibrancyEffect()
                        .vibrancyEffectStyle(.label)
                        .colorScheme(.dark)

                })
        }

        Button("Revert", systemImage: .arrowUturnLeft) {
            withAnimation {
                buttonAction()
            }
        }
        .if(alternateColored, transform: {view in
            view
                .foregroundColor(.appPrimary)
        }, elseThen: {view in
            view
                .vibrancyEffect()
                .vibrancyEffectStyle(.label)
                .colorScheme(.dark)

        })
        .padding(3)
        .font(.callout.weight(.regular))
    }
}

fileprivate struct EnableView: View {
    var alternateColored: Bool
    var action: () -> Void

    var body: some View {
        Label("Schedule doesn't look right?", systemSymbol: .exclamationmarkCircle)
            .if(alternateColored, transform: {view in
                view
                    .foregroundColor(.secondaryLabel)
            }, elseThen: {view in
                view
                    .vibrancyEffect()
                    .vibrancyEffectStyle(.secondaryLabel)

            })

        Button("Tap Here.") {
            withAnimation {
                action()
            }
        }
        .if(alternateColored, transform: {view in
            view
                .foregroundColor(.appPrimary)
        }, elseThen: {view in
            view
                .vibrancyEffect()
                .vibrancyEffectStyle(.label)
                .colorScheme(.dark)
        })
        .padding(3)
        .font(.callout.weight(.regular))
    }
}

fileprivate struct AvailabilityAlertSurvey: ViewModifier {
    @Binding var showFeedbackAlert: Bool
    @Binding var feedbackText: String
    var action: () -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .alert("Submit Feedback",
                       isPresented: $showFeedbackAlert,
                       actions: {
                    TextField("Ex. Period 2 class not showing.", text: $feedbackText)
                    Button("Submit", action: action)
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
                                 _ feedbackText: Binding<String>,
                                 action: @escaping () -> Void) -> some View {
        self.modifier(AvailabilityAlertSurvey(showFeedbackAlert: showFeedbackAlert,
                                              feedbackText: feedbackText,
                                              action: action))
    }
}


struct ScheduleFallbackSection_Previews: PreviewProvider {
    @State static var userOverride = true
    static var previews: some View {
        ZStack {
            AnimatedBlurBackground(bottomTextScreenRatio: .constant(0),
                                               dynamicBlurred: false)
            ScheduleFallbackSection(userOverrideFallback: $userOverride,
                                    alternateColored: false)
        }

    }
}
