//
//  BannerDetailView.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI
import SwiftUIVisualEffects

struct BannerDetailView: View {
    let banner: Banner
    @Binding var selected: Banner?
    var animate: Namespace.ID
    
    @State var name: String = ""
    @State var phoneNumber: String = ""
    @State var email: String = ""
    @State var school: String = ""
    @State var grade: String = ""
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    ZStack(alignment: .topLeading) {
                        BannerImage(url: banner.image)
                            .aspectRatio(1, contentMode: .fit)
                            .ignoresSafeArea()
                            .transition(.identity)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(banner.headline)
                                .bannerHeadline()
                            Text(banner.title)
                                .bannerTitle()
                            Spacer()
                            Text(banner.footnote)
                                .bannerFootnote()
                        }
                        .padding(15)
                        .padding(.top, 45) // 20
                    }
                    .ignoresSafeArea()
                    .matchedGeometryEffect(id: banner.id, in: animate)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(banner.paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .foregroundColor(.secondary)
                                .font(.headline)
                        }
                    }
                    .padding()
                    VStack(spacing: 30) {
                        Text("Sign up")
                            .font(.headline)
                        VStack(spacing: 15) {
                            if banner.requirements.contains(.name) {
                                TextField("Name", text: $name)
                                    .textFieldStyle(.roundedBorder)
                            }
                            if banner.requirements.contains(.phoneNumber) {
                                TextField("Phone number", text: $phoneNumber)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            if banner.requirements.contains(.email) {
                                TextField("Email", text: $email)
                                    .textFieldStyle(.roundedBorder)
                            }
                            if banner.requirements.contains(.school) {
                                TextField("School", text: $school)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        if banner.requirements.contains(.grade) {
                            Picker("Grade level", selection: $grade) {
                                Text("Freshman")
                                    .tag("freshman")
                                Text("Sophomore")
                                    .tag("sophomore")
                                Text("Junior")
                                    .tag("junior")
                                Text("Senior")
                                    .tag("senior")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Button("Submit") {
                            Task {
                                do {
                                    let sent = try await banner.submit(name: name,
                                                                       phoneNumber: phoneNumber,
                                                                       email: email,
                                                                       school: school,
                                                                       grade: grade)
                                    //                                    print(sent ? "Sent email" : "Could not send email")
                                }
                                catch {
                                    print("Submit error: \(error)")
                                }
                            }
                        }
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                        //                            .background(.thickMaterial)
                        .cornerRadius(8)
                        Spacer()
                            .frame(height: 300)
                    }
                    .padding()
                }
            }
            Button(action: {
                withAnimation(.spring()) {
                    selected = nil
                }
            }) {
                BlurEffect()
                    .frame(height: UIDevice.hasTopNotch ? 35 : 20)
                    .clipShape(Circle())
                    .blurEffectStyle(.systemThinMaterial)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "xmark")
                    }
            }
            .padding(.horizontal)
        }
        //        .statusBarHidden(selected != nil)
    }
}

//struct BannerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerDetailView()
//    }
//}
