//
//  GradesDetailView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/21/21.
//

import SwiftUI

struct GradesDetailView: View {
    var className: String
    var overAll: Int
    @StateObject var viewModel: GradesDetailViewModel

    var body: some View {
        ZStack {
            Color.platformSecondaryBackground.ignoresSafeArea()
            VStack {
                Text("\(overAll)%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(appSecondary)
                    .textAlign(.leading)
                    .padding(.horizontal, 20)

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
                                        .padding(5)
                                        .background(Color.platformSecondaryBackground)
                                        .roundedCorners(cornerRadius: 10)
                                        .textAlign(.leading)
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
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondaryLabel)
                                        .textAlign(.trailing)
                                        .padding(.top, 0.5)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.platformBackground)
            }
            .navigationTitle(className)
        }

    }
}
