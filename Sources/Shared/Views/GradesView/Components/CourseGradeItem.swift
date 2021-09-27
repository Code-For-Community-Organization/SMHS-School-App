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

    // Remove term annotation (... - Fall) from end of period name
    let termAnnotationRemoval = #"(- \w+)$"#
    var periodName: String {
        course.periodName
            .removingRegexMatches(pattern: termAnnotationRemoval)
            .trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Button(action: {
            showDetailView = true
        }) {
            HStack {
                NavigationLink(isActive: $showDetailView,
                               destination: {
                    GradesDetailView(className: periodName,
                                     overAll: course.gradePercentText,
                                     viewModel: .init(gradebookNumber: course.gradebookNumber,
                                                      term: course.term))
                },
                               label: {EmptyView()})
                VStack {
                    Group {
                        Text(periodName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.bottom, 1)

                        HStack {
                            Text("Period \(course.periodNum)")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(appSecondary)
                                .minimumScaleFactor(0.5)
                                .frame(width: 70)

                            Text(course.teacherName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.platformSecondaryLabel)
                            
                            Spacer()
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.trailing, 5)

                Spacer()
                Text(course.currentMark)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.platformSecondaryLabel)

                Text(course.gradePercentText)
                    .font(.title2)
                    .fontWeight(.bold)

                Image(systemSymbol: .chevronRight)
                    .font(Font.title2.weight(.semibold))
                    .foregroundColor(.secondaryLabel)
                
            }
            .foregroundColor(.label)
            .padding(15)
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
