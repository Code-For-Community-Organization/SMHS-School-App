//
//  GradesDetailRow.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 10/16/21.
//

import SwiftUI

struct GradesDetailRow: View {
    @StateObject var viewModel: GradesDetailViewModel
    @State var slider = 0.0
    var assignmentGrade: GradesDetail.Assignment
    var arrayIndex: Int

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
                        .strikethrough(assignmentGrade.editModeDropped)
                        .textAlign(.trailing)
                        .foregroundColor(Color.appPrimary)


                    let numbersCorrect = String(format: "%g", assignmentGrade.numberCorrect)
                    let numbersPossible = String(format: "%g", assignmentGrade.numberPossible)

                    Text("\(numbersCorrect)/\(numbersPossible)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .strikethrough(assignmentGrade.editModeDropped)
                        .foregroundColor(.secondaryLabel)
                        .textAlign(.trailing)
                        .padding(.top, 0.5)

                }
            }

            if viewModel.isEditModeOn {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.detailedAssignments[arrayIndex].editModeDropped.toggle()
                    }, label: {
                        Text(assignmentGrade.editModeDropped ? "Undrop" : "Drop")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 6)
                            .background(Color.appPrimary)
                            .clipShape(Capsule())
                    })
                }
                .transition(.move(edge: .bottom))
                if assignmentGrade.numberPossible > 0 {
                    Stepper(value: Binding(get: {self.slider},
                                           set: {value in
                         viewModel.detailedAssignments[arrayIndex].numberCorrect = value
                     }),
                            in: 0...assignmentGrade.numberPossible,
                            step: 1,
                            label: {EmptyView()})
                }



            }
        }
        .opacity(assignmentGrade.editModeDropped ? 0.3 : 1)
        .onAppear {
            slider = assignmentGrade.numberCorrect
        }
//        .onChange(of: slider) {value in
//            viewModel.detailedAssignments[arrayIndex].numberCorrect = value
//        }
    }
}
