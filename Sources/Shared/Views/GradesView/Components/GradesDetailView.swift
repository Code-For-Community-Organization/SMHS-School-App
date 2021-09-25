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
        ForEach(viewModel.detailedAssignments, id: \.self) {assignmentGrade in
            Text(assignmentGrade.description)
        }
    }
}

//struct GradesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GradesDetailView(viewModel: GradesDetailViewModel())
//    }
//}
