//
//  TestSwiftUIX.swift
//  SMHS (iOS)
//
//  Created by Jevon Mao on 7/25/22.
//

import SwiftUI
import SwiftUIX

struct TestSwiftUIX: View {
    var body: some View {
        VisualEffectBlurView {
            Image("SM-Field-HiRes")

         }
    }
}

struct TestSwiftUIX_Previews: PreviewProvider {
    static var previews: some View {
        TestSwiftUIX()
    }
}
