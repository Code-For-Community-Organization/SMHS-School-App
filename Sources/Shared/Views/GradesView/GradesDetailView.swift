//
//  GradesDetailView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/21/21.
//

import SwiftUI

struct GradesDetailView: View {
    var className: String
    @StateObject var viewModel: GradesDetailViewModel
    
    var body: some View {
        ZStack {
            Color.platformSecondaryBackground.ignoresSafeArea()
            VStack {
                if viewModel.overallPercent.isNaN {
                    ProgressView()
                        .textAlign(.leading)
                        .padding()
                }
                else {
                    Text("\(viewModel.overallPercent, specifier: "%g")%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(appSecondary)
                        .textAlign(.leading)
                        .padding(.horizontal, 20)
                }

                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.detailedAssignments, id: \.self) {assignmentGrade in
                            GradesDetailRow(viewModel: viewModel,
                                            assignmentGrade: assignmentGrade)
                        }
                    }
                    .padding()
                }
                .background(Color.platformBackground)
            }
            .navigationTitle(className)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.isEditModeOn.toggle()
                    }) {
                        Image(systemSymbol: .sliderVertical3)
                    }
                }
            }
            
        }

    }
}
