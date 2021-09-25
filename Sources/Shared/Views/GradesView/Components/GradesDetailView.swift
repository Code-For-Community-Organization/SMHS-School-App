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
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryLabel)
                                .textAlign(.leading)
                                .padding(.top, 1)
                            Text("Finished Grading: \(assignmentGrade.isGraded ? "YES" : "NO")")
                                .font(.footnote)
                                .foregroundColor(.secondaryLabel)
                                .textAlign(.leading)

                        }

                        Spacer()

                        VStack {
                            Text("\(String(format: "%.1f", assignmentGrade.percent))%")
                                .font(.title)
                                .fontWeight(.bold)
                                .textAlign(.trailing)

                            Text("\(assignmentGrade.numberCorrect)/\(assignmentGrade.numberPossible)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
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
