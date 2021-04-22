//
//  ViewExtensions.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

extension View {
    func typeErased() -> AnyView {AnyView(self)}
    
    //Easily align text to left or right of frame
    func textAlign(_ align: Alignment) -> AnyView {
        switch align {
        case .leading:
            return HStack{
                self
                Spacer()
            }.typeErased()
        case .trailing:
            return HStack{
                Spacer()
                self
            }.typeErased()
        default:
            return self.typeErased()
        }
    }
    //StackOverflow: https://stackoverflow.com/questions/64091415/how-to-disable-vertical-scroll-in-tabview-with-swiftui
    func disableTabViewScroll() -> some View {
        self.onAppear(perform: {
           UIScrollView.appearance().bounces = false
         })
    }
}
