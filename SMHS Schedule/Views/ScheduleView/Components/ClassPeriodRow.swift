//
//  ScheduleCardItemView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
//
//struct ClassPeriodRow: View {
//    @StateObject var viewModel = ScheduleViewModel()
//    var classPeriod: ClassPeriod
//    var startTime: String {
//        viewModel.formatMilitaryToStandardTime(classPeriod.startTime)
//    }
//    var endTime: String {
//        viewModel.formatMilitaryToStandardTime(classPeriod.endTime)
//    }
//    var body: some View {
//        VStack{
//            Group{
//                HStack(spacing: 10){
//                    Text("START: ")
//                        .calloutTextLight() +
//                    Text("\(startTime)")
//                        .calloutText()
//                    Text("END: ")
//                        .calloutTextLight() +
//                    Text("\(endTime)")
//                        .calloutText()
//                    Spacer()
//                }
//                .padding(.top, 10)
//                Text(classPeriod.description)
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                    .textAlign(.leading)
//                    .padding(.vertical, 8)
//            }
//            .padding(.horizontal, 15)
//
//        }
//        .foregroundColor(.white)
//        .background(Color.blue)
//        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//        .padding(20)
//
//    }
//}
//
//
//struct ScheduleCardItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassPeriodRow(classPeriod: ClassPeriod(startTime: .init(hours: 8, minutes: 0, seconds: 0),
//                                                     endTime: .init(hours: 9, minutes: 5, seconds: 0),
//                                                     description: "Period 1"))
//    }
//}
