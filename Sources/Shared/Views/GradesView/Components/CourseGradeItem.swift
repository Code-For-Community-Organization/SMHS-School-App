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
                                     viewModel: .init(gradebookNumber: course.gradebookNumber,
                                                      term: course.term.rawValue))
                },
                               label: {EmptyView()})
                VStack {
                    Group {
                        Text(periodName)
                            .font(.title2)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .padding(.bottom, 1)

                        HStack {
                            Text("Period \(course.periodNum)")
                                .font(.headline)
                                .foregroundColor(.appSecondary)
                            Text("•")
                                .foregroundColor(.platformSecondaryLabel)
                            Text(course.teacherName)
                                .font(.headline)
                                .foregroundColor(.platformSecondaryLabel)

                            
                            Spacer()
                        }
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

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
