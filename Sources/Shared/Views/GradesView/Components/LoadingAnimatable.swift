//
//  LoadingAnimatable.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 7/30/21.
//

import SwiftUI
import SwiftUIVisualEffects

extension View {
    func loadingAnimatable(reload: @escaping () -> Void, isLoading: Binding<Bool>) -> some View {
        ZStack {
            self
                .animation(nil)
                .onAppear(perform: reload)
                .blur(radius: isLoading.wrappedValue ? 20 : 0)
                .disabled(isLoading.wrappedValue ? true : false)
                .animation(.easeInOut)

            
            if isLoading.wrappedValue {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.white)
                    .padding(50)
                    .background(BlurEffect())
                    .blurEffectStyle(.systemThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .transition(AnyTransition.opacity.combined(with: .scale))
                    .animation(.easeInOut)
            }
        }
    }
}
