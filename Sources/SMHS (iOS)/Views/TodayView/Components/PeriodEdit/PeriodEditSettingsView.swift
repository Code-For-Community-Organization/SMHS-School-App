//
//  PeriodEditSettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI

struct PeriodEditSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @State var showActionSheet = false
    @Binding var showModal: Bool
    @State var editableSettings = [EditableSetting]()

    var body: some View {
        NavigationView {
            VStack {
                Text("Label periods 1 through 7 with customized subjects and rooms for a more organized school experience.")
                    .foregroundColor(.platformSecondaryLabel)
                    .textAlign(.leading)
                    .font(.callout)
                    .padding(.horizontal, 20)
                SettingsView {
                    Section(header: Text("Period settings")) {
                        ForEach(editableSettings.indices, id: \.self){
                            PeriodEditItem(setting: $editableSettings[$0])
                        }
                    }
                }
                
            }            
            .navigationBarTitle("Class Settings")
            .navigationBarItems(leading: Button("Clear", action: {showActionSheet = true}),
                                trailing: Button("Done", action: {
                DispatchQueue.main.async {
                    userSettings.commitEditableSettings(editableSettings)
                }
                presentationMode.wrappedValue.dismiss()

            }))
    
        }
        .navigationBarTitleDisplayMode(.inline)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Clear all Periods"),
                                 message: Text("Are you sure you want to clear all periods names?"),
                                 buttons: [.destructive(Text("Discard Changes"), action: {userSettings.resetEditableSettings()}),
                                           .cancel(Text("Keep Editing"), action: {showActionSheet = false})])
                }
        .introspectViewController{viewController in
            viewController.isModalInPresentation = true
        }
        .onAppear {
            editableSettings = userSettings.getEditableSettings()
        }
    }
}

struct PeriodEditSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditSettingsView(showModal: .constant(true))
    }
}
