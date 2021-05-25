//
//  WhyStatementView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI

struct WhyStatementView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("THE WHY\nBEHIND SMHS")
                    .font(.largeTitle, weight: .bold)
                    .textAlign(.leading)
                    .padding(.bottom)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Text("The reasons for building this project, SMHS Schedule, are private and public. On a private level, the creator is a SMHS student and need to see the class schedule several times a day. The official SMHS app is poorly built and while acheiving the function of class schedules, left plenty of room for improvements. And since Jevon had some knowledge of Swift and iOS development, he decided to make a better app for himself.\n\nBut at the same time, SMHS Schedule has a purpose on the public level. For the 1600 students attending SMHS, this app will greatly enhance students' school experience by providing a one-stop app that offers a variety of features. When compared to the official SMHS app, SMHS Schedule is designed and built better to specifically solve the issues that the official app failed on. The creator wanted to use his software skills to produce something meaningful for his school and his fellow students.")
                    .font(.system(.headline, design: .default))
                    .fontWeight(.medium)
                    .textAlign(.leading)
                    .foregroundColor(.platformSecondaryLabel)

            }
            .padding(.vertical)
            .padding(.horizontal, 25)
        }
    }
}

struct WhyStatementView_Previews: PreviewProvider {
    static var previews: some View {
        WhyStatementView()
    }
}
