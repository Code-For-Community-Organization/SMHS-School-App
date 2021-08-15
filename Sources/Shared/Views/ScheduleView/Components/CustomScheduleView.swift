//
//  CustomScheduleView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/19/21.
//

// import SwiftUI
// import Introspect
//
// struct CustomScheduleView: View {
//    @StateObject var scheduleViewModel: ScheduleViewModel
//    @StateObject var scheduleCustomViewModel = ScheduleCustomViewModel()
//    var scheduleDays: [ScheduleDay] {
//        scheduleViewModel.scheduleWeeks.flatMap{$0.scheduleDays}
//    }
//    @Binding var showModal: Bool
//    var body: some View {
//        NavigationView {
//            VStack {
//                SettingsView {
//                    Section {
//                        Picker(selection: $scheduleCustomViewModel.selection, label: Text("Choose Date")) {
//                            ForEach(scheduleDays) {
//                                Text($0.title)
//                                    .tag($0)
//                            }
//                        }
//                        .pickerStyle(WheelPickerStyle())
//                        DatePicker("Start Time", selection: $scheduleCustomViewModel.startTime, displayedComponents: .hourAndMinute)
//                        DatePicker("End Time", selection: $scheduleCustomViewModel.endTime, displayedComponents: .hourAndMinute)
//                    }
//                    Section {
//                        TextField("Title", text: $scheduleCustomViewModel.title)
//                    }
//
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarTitle("Extend Schedule")
//            .navigationBarItems(leading: Button("Cancel"){showModal = false},
//                                trailing: Button(systemImage: .calendarBadgePlus){addCustomSchedule()}
//            )
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .onAppear {
//            scheduleCustomViewModel.selection = scheduleDays.first ?? .sampleScheduleDay
//        }
//        .introspectViewController {
//            $0.isModalInPresentation = showModal
//        }
//        .alert(isPresented: $scheduleCustomViewModel.showAlert) {
//            Alert(title: "Cannot Add Schedule", message: "One or more information provided is invalid.", dismissButtonTitle: "OK")
//        }
//    }
//
//    func addCustomSchedule() {
//        let result = scheduleCustomViewModel.validateAndCreate(scheduleDay: scheduleCustomViewModel.selection)
//        if  result.validated {
//            showModal = false
//            if let indexI = scheduleViewModel.scheduleWeeks.firstIndex(  //Index for getting scheduleWeeks
//                where: {$0.scheduleDays.contains{$0.id == scheduleCustomViewModel.selection.id}
//                }),
//               let indexJ = scheduleViewModel.scheduleWeeks[indexI].scheduleDays.firstIndex(  //Index for getting nested array scheduleDays
//                where: {$0.id == scheduleCustomViewModel.selection.id
//
//                }) {
//                guard let block = result.block else {return}
//                scheduleViewModel.scheduleWeeks[indexI][indexJ].customPeriods.append(block)
//            }
//        }
//        else {scheduleCustomViewModel.showAlert = true}
//    }
// }
//
//
// struct CustomScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomScheduleView(scheduleViewModel: .mockScheduleView, showModal: .constant(true))
//    }
// }
