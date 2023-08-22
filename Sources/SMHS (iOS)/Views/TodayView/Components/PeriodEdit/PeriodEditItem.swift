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
                            VStack {
                                Text("No Results")
                                    .font(.title3)
                                    .fontWeight(.heavy)

                                Link("Report Missing Subject", destination: createSupportEmailURL())
                            }

                        }
                    }
                )
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find your class")

        }, label: {
            VStack {
                if let selection = setting.subject {
                    HStack {
                        Image(systemSymbol: .checkmarkCircleFill)
                            .foregroundColor(.appPrimary)
                        let titleBinding = Binding(get: {
                            selection.title
                        }, set: {
                            setting.subject?.title = $0
                        })
                        TextField("Enter subject", text: titleBinding)
                    }
                }
                else {
                    Text(setting.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Picker(selection: $setting.room, content: {
                    Text("Default").tag(nil as Classroom?)
                    ForEach(Classroom.allCases.sorted(), id: \.self) { room in
                            Text(room.rawValue).tag(room as Classroom?)
                        }
                }, label: {
                    HStack {
                        Image(systemName: "door.left.hand.closed")
                            .foregroundColor(.appPrimary)
                        Text("Room")
                    }

                })
                .pickerStyle(.menu)
                .tint(.appPrimary)


            }

        })
        .onChange(of: setting.subject) {_ in
            isNavigationActive = false
        }

//        TextField(setting.title, text: $setting.subject?.name)
//            .disableAutocorrection(true)
//
    }

    private func createSupportEmailURL() -> URL {
            var components = URLComponents(string: "mailto:support@sm6hs.app")!
            components.queryItems = [
                URLQueryItem(name: "subject", value: "[BUG REPORT SMHS] - Missing Subject"),
                URLQueryItem(name: "body", value: "Hello,\n\nI wanted to report a missing subject:\n\n")
            ]

            return components.url!
        }
}

struct PeriodEditItem_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditSettingsView(showModal: .constant(true))
            .environmentObject(UserSettings())
    }
}
