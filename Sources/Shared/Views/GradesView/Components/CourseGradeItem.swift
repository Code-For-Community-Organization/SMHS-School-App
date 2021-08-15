//
//  CourseGradeItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI

struct CourseGradeItem: View {
    var course: CourseGrade

    var body: some View {
        HStack {
            VStack {
                Group {
                    Text("PERIOD \(course.periodNum)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Text(course.periodName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, 1)
                    Text(course.teacherName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.platformSecondaryLabel)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Text(course.currentMark)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.platformSecondaryLabel)

            Text("\(course.gradePercent)%")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding(12)
        .background(Color.platformSecondaryBackground)
        .roundedCorners(cornerRadius: 10)
    }
}

struct CourseGradeItem_Previews: PreviewProvider {
    static var previews: some View {
        CourseGradeItem(course: CourseGrade(periodNum: 1, periodName: "English", teacherName: "John Cena", gradePercent: "100%", currentMark: "A+", isPrior: false))
    }
}
