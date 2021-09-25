//
//  CourseGradeItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI

struct CourseGradeItem: View {
    @State var showDetailView = false
    var course: CourseGrade.GradeSummary

    var body: some View {
        Button(action: {
            showDetailView = true
        }) {
            HStack {
                NavigationLink(isActive: $showDetailView,
                               destination: {
                    GradesDetailView(viewModel: .init(gradebookNumber: course.gradebookNumber,
                                                      term: course.term))
                },
                               label: {EmptyView()})
                VStack {
                    Group {
                        Text("PERIOD \(course.periodNum)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(appSecondary)

                        Text(course.periodName)
                            .font(.title2)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.bottom, 1)
//                        Text(course.teacherName)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.platformSecondaryLabel)
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

                Image(systemSymbol: .chevronRight)
                    .font(Font.title2.weight(.semibold))
                    .foregroundColor(.secondaryLabel)
                
            }
            .foregroundColor(.label)
            .padding(12)
            .background(Color.platformSecondaryBackground)
            .roundedCorners(cornerRadius: 10)
        }

    }
}

//struct CourseGradeItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseGradeItem(course: CourseGrade.GradeSummary(periodNum: 1, periodName: "English", gradePercent: "100%", currentMark: "A+"))
//    }
//}
