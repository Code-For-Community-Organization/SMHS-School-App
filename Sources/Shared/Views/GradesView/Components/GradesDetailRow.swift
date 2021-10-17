//
//  GradesDetailRow.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 10/16/21.
//

import SwiftUI

struct GradesDetailRow: View {
    @StateObject var viewModel: GradesDetailViewModel
    var assignmentGrade: GradesDetail.Assignment

    var body: some View {
        Divider()
        VStack {
            HStack {
                Text("Finished Grading: \(assignmentGrade.isGraded ? "YES" : "NO")")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryLabel)
                    .padding(5)
                    .background(Color.platformSecondaryBackground)
                    .roundedCorners(cornerRadius: 10)
                    .textAlign(.leading)
                Spacer()
                Group {
                    if let dateDigits = assignmentGrade.dateCompleted?.digits {
                        Text("Date Completed: \(viewModel.formatUnixDate(dateDigits))")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    else {
                        Text("Date Completed: Unknown")
                    }
                }
                .font(Font.caption.weight(.semibold))
                .foregroundColor(Color.tertiaryLabel)

            }

            HStack {
                VStack {
                    Text(assignmentGrade.description.localizedCapitalized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .textAlign(.leading)
                    Text(assignmentGrade.category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondaryLabel)
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

            if viewModel.isEditModeOn {
                HStack {
                    Spacer()
                    Button(action: {
                        if let index = viewModel.detailedAssignments.firstIndex(of: assignmentGrade) {
                            viewModel.detailedAssignments[index].editModeDropped = true
                        }

                    }, label: {
                        Text("Drop")
                            .fontWeight(.semibold)
                            .foregroundColor(appPrimary)
                            .padding(3)
                            .background(Color.white)
                            .clipShape(Capsule())
                    })
                }
                .transition(.move(edge: .bottom))
            }
        }
        .opacity(assignmentGrade.editModeDropped ? 0.5 : 1)
    }
}
