//
//  PeriodEditItem.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI
import SwiftlySearch

struct PeriodEditItem: View {
    @Binding var setting: EditableSetting
    @State var searchText = ""
    @State var isNavigationActive = false
    //@State var selection: Course?

    var searchResults: [Course] {
        if searchText.isEmpty {
            return Course.getAll()
        }
        else {
            return Course.getAll().filter{$0.title.localizedCaseInsensitiveContains(searchText)}
        }
    }

    var body: some View {
        NavigationLink(isActive: $isNavigationActive, destination: {
            List(searchResults, id: \.self, selection: $setting.subject) {
                Text($0.title)
                }
                .overlay(
                    Group {
                        if searchResults.isEmpty && !searchText.isEmpty {
                            Text("No Results")
                                .font(.title3)
                                .fontWeight(.heavy)
                        }
                    }
                )
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find your class")

        }, label: {
            VStack {
                if let selection = setting.subject {
                    Label(selection.title, systemSymbol: .checkmarkCircleFill)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                else {
                    Text(setting.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Picker(selection: $setting.room, content: {
                    Text("Select a room").tag(nil as Classroom?)
                    ForEach(Classroom.allCases.sorted(), id: \.self) { room in
                            Text(room.rawValue).tag(room as Classroom?)
                        }
                }, label: {
                    Label("Room", systemImage: "door.left.hand.closed")
                })
                .pickerStyle(.menu)

            }

        })
        .onChange(of: setting.subject) {_ in
            isNavigationActive = false
        }

//        TextField(setting.title, text: $setting.subject?.name)
//            .disableAutocorrection(true)
//
    }
}

struct PeriodEditItem_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditSettingsView(showModal: .constant(true))
            .environmentObject(UserSettings())
    }
}
