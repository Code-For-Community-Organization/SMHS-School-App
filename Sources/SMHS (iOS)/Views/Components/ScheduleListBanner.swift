//
//  ScheduleListHeader.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/18/21.
//

import SwiftUI

struct ScheduleListBanner: View {
    @AppStorage("calendarBannerInitialLoad") var firstTime = true
    @State var animate = false
    @Binding var present: Bool
    var action: () -> ()
    var geometryProxy: GeometryProxy
    var body: some View {
        VStack {
            VStack {
                Button(action: action) {
                    Text("Master Calendar")
                        .font(.body)
                        .fontWeight(.semibold)
                        .textCase(nil)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                }
                .background(Color.platformBackground)
                .foregroundColor(.appPrimary)
                .clipShape(Capsule(style: .continuous))
                Text("View calendar for all school events.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .textCase(nil)
            }
            .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        }
                          // 20 padding on each side
        .frame(width: geometryProxy.size.width)
        //.fixedSize(horizontal: true, vertical: true)
        .background(Color.appPrimary)
//        .if(firstTime, transform: {
//            $0
//                .scaleEffect(x: 1, y: animate ? 1 : 0, anchor: .top)
//        })
//        .animation(Animation.easeInOut)
//        .onAppear {
//            if firstTime {
//                animate = true
//                firstTime = false
//            }
//        }
        .padding(.vertical, -5)
        //.roundedCorners(cornerRadius: 10)
    }
}

