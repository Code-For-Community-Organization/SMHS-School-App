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
    var body: some View {
        NavigationView {
            VStack {
                Text("Customize and edit your class names for each period. (Ex. Period 2 might be English)")
                    .foregroundColor(.platformSecondaryLabel)
                    .textAlign(.leading)
                    .font(.callout)
                    .padding(.horizontal, 20)
                SettingsView {
                    Section(header: Text("Period settings")) {
                        ForEach(userSettings.editableSettings.indices, id: \.self){
                            PeriodEditItem(setting: $userSettings.editableSettings[$0])
                        }
                    }
                }
                
            }
            .navigationBarTitle("Period Names")
            .navigationBarItems(leading: Button("Clear", action: {showActionSheet = true}),
                                trailing: Button("Done", action: {
                userSettings.commitEditableSettings()
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
    }
}

struct PeriodEditSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditSettingsView(showModal: .constant(true))
    }
}
