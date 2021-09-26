//
//  GradesDetailView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/21/21.
//

import SwiftUI

struct GradesDetailView: View {
    @StateObject var viewModel: GradesDetailViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.detailedAssignments, id: \.self) {assignmentGrade in
                    Divider()
                    HStack {
                        VStack {
                            Text(assignmentGrade.description)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .textAlign(.leading)
                            Text(assignmentGrade.category)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondaryLabel)
                                .textAlign(.leading)
                            Text("Finished Grading: \(assignmentGrade.isGraded ? "YES" : "NO")")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryLabel)
                                .textAlign(.leading)
                                .padding(.top, 1)
                        }

                        Spacer()

                        VStack {
                            Text("\(String(format: "%.1f", assignmentGrade.percent))%")
                                .font(.title)
                                .fontWeight(.bold)
                                .textAlign(.trailing)
                                .foregroundColor(appPrimary)

                            let numbersCorrect = String(format: "%g", assignmentGrade.numberCorrect)
                            let numbersPossible = String(format: "%g", assignmentGrade.numberPossible)

                            Text("\(numbersCorrect)/\(numbersPossible)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(appSecondary)
                                .textAlign(.trailing)
                                .padding(.top, 1)
                        }


                    }

                }
            }
            .padding()
        }


    }
}
